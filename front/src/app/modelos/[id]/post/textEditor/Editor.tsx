'use client'

import { FC, HTMLAttributes, memo, useEffect } from "react";
import { restoreCaretPosition, storeCaretPosition } from '@/utils/caret';
import {
  arrobaHighlighter,
  hashtagHighlighter,
  httpsHighlighter } from '@/utils/highlights/highlighters';
import { composeHighlighters } from '@/utils/highlights/composeHighlighters';
import { EditorProps, Posteo } from "@/types";

const Editor:FC<EditorProps> = memo(({
  onChangePosteo,
  onKeyUp,
  editorRef,
  ...props }) => {
  const highlight = (texto:string):string => {
    const { html, meta } = composeHighlighters(
        hashtagHighlighter,
        arrobaHighlighter,
        httpsHighlighter)(texto);
      onChangePosteo({ meta, texto})
      // if (meta.urls) embededRef.current?.setUrls(meta.urls);
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
  return (
    <div
        spellCheck="false"
        ref={editorRef}
        contentEditable
        onKeyUp={onKeyUp}
        onInput={onInput}
        style={{ padding: '10px', minHeight: '100px' }}
        suppressContentEditableWarning
        {...props}
    />
  );
});

export default Editor;