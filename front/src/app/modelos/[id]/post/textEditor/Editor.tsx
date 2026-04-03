'use client'

import { ForwardedRef, forwardRef, memo, useEffect, useImperativeHandle, useRef, useState } from "react";
import { restoreCaretPosition, storeCaretPosition } from '@/utils/caret';
import {
  arrobaHighlighter,
  hashtagHighlighter,
  httpsHighlighter } from '@/utils/highlights/highlighters';
import { composeHighlighters } from '@/utils/highlights/composeHighlighters';
import { EditorProps, EmbededHandle } from "@/types";
import { usePasteImage } from "@/hooks/usePasteImage";
import Embeded from "./Images/embeded";

const Editor = memo<EditorProps>(({
  onChangePosteo,
  onKeyUp,
  text,
  ...props }) => {
  const editorRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
      if(editorRef.current) editorRef.current.innerHTML = highlight(text);
  }, [text])
  const [urlEmbeded, setUrlEmbeded] = useState<string>('');
  const { imageUrl, isLoading } = usePasteImage(editorRef.current);
  const highlight = (texto:string):string => {
    const { html, meta } = composeHighlighters(
        hashtagHighlighter,
        arrobaHighlighter,
        httpsHighlighter)(texto);
      onChangePosteo({ meta, texto})
      if (meta.urls) setUrlEmbeded(meta.urls[0]);
      return html;
  }
  const onInput = async (ev: React.FormEvent<HTMLDivElement>) => {
    const editor = editorRef.current;
    if(!editor) return
    const native = ev.nativeEvent as InputEvent;
    const inputType = native.inputType;
    if(inputType === 'insertCompositionText' || inputType === 'deleteCompositionText') return
    const pos = storeCaretPosition(editor)
    editor.innerHTML = highlight(editor.innerText)
    restoreCaretPosition(editor, pos);
  };
  return (<>
      <div
          spellCheck="false"
          ref={editorRef}
          contentEditable
          onKeyUp={onKeyUp}
          onInput={onInput}
          style={{ padding: '10px', minHeight: '100px',
            border: '1px solid #ccc', borderRadius: '4px' }}
          suppressContentEditableWarning
          {...props}
      />
          {isLoading ?
            <div>loading</div> :
            <Embeded imageUrl={imageUrl} urlEmbeded={urlEmbeded}/>
          }
      </>);
});

export default Editor;