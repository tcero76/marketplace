export type ImagePasteRes = {
    filename:string
    path:string
}

export type EmbededProps = {
  imageUrl: string | null
  urlEmbeded?:string
}

export type EmbededHandle = {
  setUrls: (urls:string[]) => void
}

export type EmbededType = {
  type: string
  title: string
  description: string
  thumbnail: string
  embed_html:string
  url: string
}

export type PasteImageResult = {
  imageUrl: string | null;     // la URL final de la imagen subida
  isLoading: boolean;          // true mientras se sube
  error: string | null;        // mensaje de error si falla
}