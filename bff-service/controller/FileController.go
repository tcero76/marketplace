package controller

import (
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/labstack/echo/v4"
	logConfig "github.com/tcero76/marketplace/config"
)

type FileController struct {
	log *logConfig.LoggerLogstash
}

func NewFileController(log *logConfig.LoggerLogstash) *FileController {
	return &FileController{log}
}

func (h *FileController) UploadImage() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Uploading image")
		file, err := c.FormFile("image")
		if err != nil {
			h.log.Error("Error retrieving the file: " + err.Error())
			return echo.NewHTTPError(http.StatusBadRequest, "image is required")
		}

		src, err := file.Open()
		if err != nil {
			h.log.Error("Error opening the file: " + err.Error())
			return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
		}
		defer src.Close()

		uploadDir := os.Getenv("UploadImages")
		if err := os.MkdirAll(uploadDir, 0755); err != nil {
			h.log.Error("Error creating upload directory: " + err.Error())
			return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
		}

		dstPath := filepath.Join(uploadDir, file.Filename)

		dst, err := os.Create(dstPath)
		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
		}
		defer dst.Close()

		if _, err := dst.ReadFrom(src); err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
		}

		return c.JSON(http.StatusOK, echo.Map{
			"filename": file.Filename,
			"path":     dstPath,
		})
	}
}

func (h *FileController) GetImage() echo.HandlerFunc {
	return func(c echo.Context) error {
		h.log.Info("Getting image")
		name := c.Param("name")
		h.log.Debug("Image name: " + name)
		path := filepath.Join(os.Getenv("UploadImages"), filepath.Clean(name))
		h.log.Debug("Image path: " + path)
		file, err := os.Open(path)
		if err != nil {
			h.log.Error("Error opening the file: " + err.Error())
			return echo.NewHTTPError(http.StatusNotFound)
		}
		defer file.Close()
		buf := make([]byte, 512)
		_, _ = file.Read(buf)
		contentType := http.DetectContentType(buf)
		file.Seek(0, 0)
		c.Response().Header().Set(echo.HeaderContentType, contentType)
		c.Response().WriteHeader(http.StatusOK)
		_, err = io.Copy(c.Response(), file)
		h.log.Error("Error copying the file: " + err.Error())
		return err
	}
}
