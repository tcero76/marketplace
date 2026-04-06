import { ComponentPropsWithoutRef } from 'react'
import { Meta } from './highlight'

export type Posteo = {
    id:string
    meta:Meta
    texto:string
  }

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
  text:string
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type EditorProps = {
  text:string
  onChangePosteo:(posteo:Posteo) => void
  onKeyUp: React.KeyboardEventHandler<HTMLDivElement>
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