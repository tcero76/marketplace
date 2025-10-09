import { ForwardedRef, forwardRef, useImperativeHandle, useRef } from 'react';
import TextFormat from './TextFormat.tsx';
import { type TextEditorProps,
  type TextEditorType,
  type TextFormatType } from '../../../types/index.ts';

const TextEditor = forwardRef<TextEditorType,TextEditorProps>(({onChangePosteo, ...props},ref:ForwardedRef<TextEditorType>) => {
  const textFormatRef = useRef<TextFormatType>({ cleanInput:() => null });
  useImperativeHandle(ref,()=>({
    cleanInput:() => textFormatRef.current.cleanInput()
  }))
  const highlight = (texto:string):string => {
      const regex = /#[\p{L}\p{N}_]+/gu;
      const menciones = texto.match(regex) ?? [];
      onChangePosteo({menciones, texto})
      return texto.replace(regex, (palabra) => {
        const safe = palabra
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;");
        return `<span class="highlight" contenteditable="true">${safe}</span>`;
      });
  }
  return <TextFormat highlight={highlight} ref={textFormatRef} { ...props }/>
});

export default TextEditor;