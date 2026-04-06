import { RefObject, useCallback, useEffect, useState } from 'react';
import { restoreCaretPosition, storeCaretPosition } from '@/utils/caret';
import {
  arrobaHighlighter,
  hashtagHighlighter,
  httpsHighlighter } from '@/utils/highlights/highlighters';
import { composeHighlighters } from '@/utils/highlights/composeHighlighters';
import EmbededComponent from "@/app/modelos/[id]/post/textEditor/Images/embeded";
import { Posteo } from '@/types';

type UseFormatTextProps = {
  onChangePosteo:(posteo:Posteo) => void
  editorRef: RefObject<HTMLDivElement | null>
  imageUrl:string | null
  posteo:Posteo
}

type UseFormatTextReturn = {
    onInput: (ev: React.FormEvent<HTMLDivElement>) => Promise<void>;
    Embeded: React.JSX.Element | null;
}

const useFormatText = ({onChangePosteo, editorRef, imageUrl, posteo}:UseFormatTextProps):UseFormatTextReturn => {
  const [urlEmbeded, setUrlEmbeded] = useState<string>('');
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor || !posteo) return;
    editor.innerHTML = highlight(posteo.texto);
  }, [editorRef,posteo]);
  const highlight =  (texto:string):string => {
    const { html, meta } = composeHighlighters(
        hashtagHighlighter,
        arrobaHighlighter,
        httpsHighlighter)(texto);
      onChangePosteo({ ...posteo, texto, meta });
      if (meta.urls) setUrlEmbeded(meta.urls[0]);
      return html;
  }
  const onInput = async (ev: React.FormEvent<HTMLDivElement>) => {
    const editor = editorRef.current;
    if (!editor) return;
    const native = ev.nativeEvent as InputEvent;
    const inputType = native.inputType;
    if(inputType === 'insertCompositionText' || inputType === 'deleteCompositionText') return
    const pos = storeCaretPosition(editor)
    editor.innerHTML = highlight(editor.innerText)
    restoreCaretPosition(editor, pos);
  }
  const Embeded = <EmbededComponent imageUrl={imageUrl} urlEmbeded={urlEmbeded}/>
    return {
        onInput,
        Embeded
    }
}

export default useFormatText;