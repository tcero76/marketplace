import { RefObject, useEffect, useState } from 'react';
import { restoreCaretPosition, storeCaretPosition } from '@/utils/caret';
import {
  arrobaHighlighter,
  hashtagHighlighter,
  httpsHighlighter } from '@/utils/highlights/highlighters';
import { composeHighlighters } from '@/utils/highlights/composeHighlighters';
import EmbededComponent from "@/app/modelos/[id]/post/textEditor/Images/embeded";
import { Posteo, PosteoRaw } from '@/types';

type UseFormatTextProps = {
  onChangePosteo:(posteoRaw:PosteoRaw) => void
  editorRef: RefObject<HTMLDivElement | null>
  imageUrl:string | null
  posteo:Posteo | null
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
    const { html } = highlight(posteo.texto);
    editor.innerHTML = html;
  }, []);
  const highlight =  (texto:string) => {
    const { html, metaRaw } = composeHighlighters(
        hashtagHighlighter,
        arrobaHighlighter,
        httpsHighlighter)(texto);
      return { html, metaRaw };
  }
  const onInput = async (ev: React.FormEvent<HTMLDivElement>) => {
    const editor = editorRef.current;
    if (!editor) return;
    const native = ev.nativeEvent as InputEvent;
    const inputType = native.inputType;
    if(inputType === 'insertCompositionText' || inputType === 'deleteCompositionText') return
    const pos = storeCaretPosition(editor)
    const {html, metaRaw} = highlight(editor.innerText)
    editor.innerHTML = html;
    restoreCaretPosition(editor, pos);
    onChangePosteo({
      id: posteo?.id,
      userId: posteo?.userId,
      texto: editor.innerText ?? "",
      metaRaw:{
        urls: metaRaw.urls,
        mentions: metaRaw.mentions,
        hashtags: metaRaw.hashtags } } as PosteoRaw)
    if (metaRaw.urls) setUrlEmbeded(metaRaw.urls[0]);
  }
  const Embeded = <EmbededComponent imageUrl={imageUrl} urlEmbeded={urlEmbeded}/>
    return {
        onInput,
        Embeded
    }
}

export default useFormatText;