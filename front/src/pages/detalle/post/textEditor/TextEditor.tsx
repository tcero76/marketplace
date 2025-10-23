import { ForwardedRef, forwardRef, useImperativeHandle, useRef } from 'react';
import TextFormat from './TextFormat.tsx';
import { Posteo, type TextEditorProps,
  type TextEditorType,
  type TextFormatType } from '../../../../types/index.ts';

const initialTextEditorState: TextFormatType = {
  cleanInput:() => null,
  setPosteo:(_:string) => null
}
const initialPosteo: Posteo = { menciones: [], texto: '', id:'', userId: '' };

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
      const regex = /#[\p{L}\p{N}_]+/gu;
      const menciones = texto.match(regex) ?? [];
      onChangePosteo({ ...posteoRef.current, menciones, texto})
      return texto.replace(regex, (palabra) => {
        const safe = palabra
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;");
        return `<span class="highlight" contenteditable="true">${safe}</span>`;
      });
  }
  return <TextFormat
            highlight={highlight}
            ref={textFormatRef}
            { ...props }
          />
});

export default TextEditor;