import { ComponentPropsWithoutRef } from 'react'

export type Posteo = {
    menciones:string[]
    texto:string
  }

  export type TextEditorType = {
    cleanInput:() => void
  }
  
  export type TextFormatType = {
    cleanInput:() =>  void
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