
export type MetaKey = "hashtags" | "mentions" | "urls"
export type Meta = Partial<Record<MetaKey, string[]>>

export type HighlightResult = {
  html: string
  meta: Partial<Record<string, string[]>>
}

export type Highlighter = (text: string) => HighlightResult

export type AutocompleteConfig = {
  trigger: string
  categories: string[]
  maxResults?: number
}

