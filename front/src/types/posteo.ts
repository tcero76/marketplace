import { ComponentPropsWithoutRef } from 'react'

export type Posteo = {
    menciones:string[]
    texto:string
    id: string
    userId: string
  }

export type TextEditorType = {
  cleanInput:() => void
  setPosteo:(posteo:Posteo) => void
}

export type TextFormatType = {
  cleanInput:() =>  void
  setInput:(text:string) => void
}
export type TextEditorProps = {
  onChangePosteo:(posteo:Posteo) => void
} & ComponentPropsWithoutRef<'div'>

export type TextFormatProps = {
  highlight:(text:string) => string
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