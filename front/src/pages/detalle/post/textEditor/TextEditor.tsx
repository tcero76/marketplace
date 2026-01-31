import { ForwardedRef, forwardRef, useImperativeHandle, useRef } from 'react';
import TextFormat from './TextFormat.tsx';
import { Posteo, type TextEditorProps,
  type TextEditorType,
  type TextFormatType } from '../../../../types/index.ts';
import {
  arrobaHighlighter,
  hashtagHighlighter,
  httpsHighlighter } from '../../../../utils/highlights/highlighters.ts';
import { composeHighlighters } from '../../../../utils/highlights/composeHighlighters.ts';

const initialTextEditorState: TextFormatType = {
  cleanInput:() => null,
  setInput:() => null
}
const initialPosteo: Posteo = { meta: {}, texto: '', id:'', userId: '' };
const TextEditor = forwardRef<TextEditorType,TextEditorProps>(({onChangePosteo, ...props},ref:ForwardedRef<TextEditorType>) => {
  const textFormatRef = useRef<TextFormatType>(initialTextEditorState);
  const posteoRef = useRef<Posteo>(initialPosteo);
  useImperativeHandle(ref,()=>({
    cleanInput:() => textFormatRef.current.cleanInput(),
    setPosteo:(posteo) => {
      posteoRef.current = posteo
      textFormatRef.current.setInput(posteo.texto)
    }
  }))
  const highlight = (texto:string):string => {
    const { html, meta } = composeHighlighters(
        hashtagHighlighter,
        arrobaHighlighter,
        httpsHighlighter)(texto);
      onChangePosteo({ ...posteoRef.current, meta, texto})
      return html;
  }
  return <TextFormat
            highlight={highlight}
            ref={textFormatRef}
            { ...props }
          />
});

export default TextEditor;