package controller

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/labstack/echo/v4"
	logger "github.com/tcero76/marketplace/config"
)

type LinkPreview struct {
	Type        string `json:"type"`
	Title       string `json:"title,omitempty"`
	Description string `json:"description,omitempty"`
	Thumbnail   string `json:"thumbnail,omitempty"`
	EmbedHTML   string `json:"embed_html,omitempty"`
	URL         string `json:"url"`
	Error       string `json:"error,omitempty"`
}

type AnalyzeContext struct {
	URL    string
	Doc    *goquery.Document
	Client *http.Client
}

func analyzeLink(targetURL string) (*LinkPreview, error) {
	ctx, err := prepareContext(targetURL)
	if err != nil {
		return nil, err
	}

	if p := tryKnownOEmbed(ctx); p != nil {
		return p, nil
	}

	if p := tryDiscoveryOEmbed(ctx); p != nil {
		return p, nil
	}

	if p := tryOpenGraph(ctx); p != nil {
		return p, nil
	}

	return &LinkPreview{
		Type: "none",
		URL:  targetURL,
	}, nil
}

func prepareContext(targetURL string) (*AnalyzeContext, error) {
	client := &http.Client{
		Timeout: 5 * time.Second,
	}
	req, err := http.NewRequest("GET", targetURL, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (LinkPreviewBot/1.0)")
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return &AnalyzeContext{
			URL:    targetURL,
			Client: client,
		}, nil
	}
	body, err := io.ReadAll(io.LimitReader(resp.Body, 2<<20))
	if err != nil {
		return nil, err
	}
	doc, err := goquery.NewDocumentFromReader(strings.NewReader(string(body)))
	if err != nil {
		return nil, err
	}
	return &AnalyzeContext{
		URL:    targetURL,
		Doc:    doc,
		Client: client,
	}, nil
}

func tryKnownOEmbed(ctx *AnalyzeContext) *LinkPreview {
	if ctx.Doc == nil {
		return nil
	}
	if strings.Contains(ctx.URL, "youtube.com") || strings.Contains(ctx.URL, "youtu.be") {
		oembedURL := "https://www.youtube.com/oembed?format=json&url=" +
			url.QueryEscape(ctx.URL)
		return fetchOEmbed(ctx, oembedURL)
	}
	return nil
}

func tryDiscoveryOEmbed(ctx *AnalyzeContext) *LinkPreview {
	if ctx.Doc == nil {
		return nil
	}

	var result *LinkPreview

	ctx.Doc.Find(`link[type="application/json+oembed"]`).EachWithBreak(
		func(_ int, s *goquery.Selection) bool {
			href := s.AttrOr("href", "")
			if href == "" {
				return true
			}

			oembedURL := resolveURL(ctx.URL, href)
			if p := fetchOEmbed(ctx, oembedURL); p != nil {
				result = p
				return false
			}
			return true
		},
	)

	return result
}

func tryOpenGraph(ctx *AnalyzeContext) *LinkPreview {
	if ctx.Doc == nil {
		return nil
	}

	title := ctx.Doc.Find(`meta[property="og:title"]`).AttrOr("content", "")
	desc := ctx.Doc.Find(`meta[property="og:description"]`).AttrOr("content", "")
	img := ctx.Doc.Find(`meta[property="og:image"]`).AttrOr("content", "")
	video := ctx.Doc.Find(`meta[property="og:video"]`).AttrOr("content", "")

	if title == "" && img == "" {
		return nil
	}

	embed := ""
	if video != "" {
		embed = fmt.Sprintf(
			`<iframe src="%s" frameborder="0" allowfullscreen></iframe>`,
			video,
		)
	}

	return &LinkPreview{
		Type:        "og",
		Title:       title,
		Description: desc,
		Thumbnail:   img,
		EmbedHTML:   embed,
		URL:         ctx.URL,
	}
}

func fetchOEmbed(ctx *AnalyzeContext, oembedURL string) *LinkPreview {
	req, err := http.NewRequest("GET", oembedURL, nil)
	if err != nil {
		return nil
	}

	req.Header.Set("User-Agent", "Mozilla/5.0 (LinkPreviewBot/1.0)")

	resp, err := ctx.Client.Do(req)
	if err != nil || resp.StatusCode != http.StatusOK {
		return nil
	}
	defer resp.Body.Close()

	var data map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return nil
	}

	return &LinkPreview{
		Type:        "oembed",
		Title:       getString(data, "title"),
		Description: getString(data, "author_name"),
		Thumbnail:   getString(data, "thumbnail_url"),
		EmbedHTML:   getString(data, "html"),
		URL:         ctx.URL,
	}
}

func getString(m map[string]interface{}, key string) string {
	if v, ok := m[key]; ok {
		if s, ok := v.(string); ok {
			return s
		}
	}
	return ""
}

func resolveURL(base, ref string) string {
	u, err := url.Parse(ref)
	if err != nil {
		return ""
	}
	if u.IsAbs() {
		return ref
	}

	b, err := url.Parse(base)
	if err != nil {
		return ""
	}

	return b.ResolveReference(u).String()
}

func GetEmbeded(log *logger.LoggerLogstash) echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Info("EmbedController - GetEmbeded")
		url := c.QueryParam("url")
		preview, err := analyzeLink(url)
		if err != nil {
			panic(err)
		}

		fmt.Printf("%+v\n", preview)
		return c.JSON(http.StatusOK, preview)
	}
}
