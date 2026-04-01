'use client'

import { ForwardedRef, forwardRef, useImperativeHandle, useRef } from 'react';
import TextFormat from './TextFormat';
import { EmbededHandle, Posteo, type TextEditorProps,
  type TextEditorType,
  type TextFormatType } from '@/types/index';
import Embeded from './Images/embeded';
import { usePasteImage } from '@/hooks/usePasteImage';

const initialTextEditorState: TextFormatType = {
  cleanInput:() => null,
  setInput:() => null,
  getInput:() => null
}
const initialPosteo: Posteo = { meta: {}, texto: '', id:'' };
const TextEditor = forwardRef<TextEditorType,TextEditorProps>(({
  onChangePosteo, ...props},ref:ForwardedRef<TextEditorType>) => {
  const textFormatRef = useRef<TextFormatType>(initialTextEditorState);
  const posteoRef = useRef<Posteo>(initialPosteo);
  const embededRef = useRef<EmbededHandle>(null);
  useImperativeHandle(ref,()=>({
    cleanInput:() => textFormatRef.current.cleanInput(),
    setPosteo:(posteo) => {
      posteoRef.current = posteo
      textFormatRef.current.setInput(posteo.texto)
    }
  }))
  const { imageUrl, isLoading } = usePasteImage(textFormatRef?.current.getInput());
  return (<>
          <TextFormat
            onChangePosteo={onChangePosteo}
            ref={textFormatRef}
            { ...props }
          />
          {isLoading ?
            <div>loading</div> :
            <Embeded imageUrl={imageUrl} ref={embededRef}/>
          }
          </>)
});

export default TextEditor;