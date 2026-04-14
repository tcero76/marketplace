import { ComponentPropsWithoutRef } from 'react'
import { Tses } from './ts'
import { Servicios } from './servicios'

  type PosteoBase = {
      id:string
      texto:string
      userId:string
  }

  export type Posteo = PosteoBase &{
    meta:Meta
  }
  
  export type PosteoRaw = PosteoBase &{
    metaRaw: MetaRaw
  }

export type MetaRaw = {
  mentions?: string[]
  hashtags?: string[]
  urls: string[]
}

export type Meta = {
  mentions: Tses[]
  hashtags: Servicios[]
  urls: string[]
}

export type HighlightResult = {
  html: string
  metaRaw: MetaRaw
  cleanText: string
}

export type Highlighter = (text: string) => HighlightResult

export type TextEditorType = {
  cleanInput:() => void
  setText:(texto:string) => void
}
export type TextFormatType = {
  cleanInput:() =>  void
  setInput:(text:string) => void
  getInput:() => HTMLDivElement | null
}
export type TextEditorProps = {
  text:string
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type TextFormatProps = {
  posteo:Posteo | null
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type EditorProps = {
  posteo:Posteo | null
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type TextAndPos = {
  text:string
  pos:number
}

export type Posts = {
  id: number
  idModelos:number
  idJob:number
  descripcion:string
  modelo:string
  fecharegistro:Date
}

export type PostProps = {
  index: Posteo
  editar:(posteo:Posteo) => void
}

export type EditorHandle = {
  cleanInput: () => void,
}