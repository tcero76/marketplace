import { ComponentPropsWithoutRef } from 'react'
import { Meta } from './highlight'

export type Posteo = {
    meta:Meta
    texto:string
    userId:string
  }

export type TextEditorType = {
  cleanInput:() => void
  setPosteo:(posteo:Posteo) => void
}

export type TextFormatType = {
  cleanInput:() =>  void
  setInput:(text:string) => void
  getInput:() => HTMLDivElement | null
}
export type TextEditorProps = {
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type TextFormatProps = {
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type EditorProps = {
  onChangePosteo:(posteo:Posteo) => void
  editorRef: React.RefObject<HTMLDivElement | null>
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