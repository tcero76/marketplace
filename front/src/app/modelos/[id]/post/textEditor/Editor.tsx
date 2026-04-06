'use client'

import { FC, useRef } from "react";
import { EditorProps } from "@/types";
import { usePasteImage } from "@/hooks/usePasteImage";
import useFormatText from "@/hooks/useFormatText";
import { useAutocomplete } from '@/hooks/useAutocomplete';
import { useGetTsesQuery, useGetTopicsQuery } from '@/http/api';

const Editor:FC<EditorProps> = ({ onChangePosteo, posteo, ...props }) => {
  const editorRef = useRef<HTMLDivElement>(null);
  const { imageUrl, isLoading } = usePasteImage(editorRef);
  const { onInput, Embeded } = useFormatText({ onChangePosteo, editorRef, imageUrl, posteo })
  const { data:topics } = useGetTopicsQuery()
  const hashtagAutocomplete = useAutocomplete({ trigger: '#', categories: topics?.map(t => t.nombre) ?? [] });
  const { data:tses } = useGetTsesQuery()
  const mentionAutocomplete = useAutocomplete({ trigger: '@', categories: tses?.map(t =>  t.nombre ) ?? [] });
  const onKeyUp = (e: React.KeyboardEvent<HTMLDivElement>) => {
    mentionAutocomplete.onKey(e);
    hashtagAutocomplete.onKey(e);
  }
  if(!posteo) return <div>Cargando...</div>
  return (
    <div>
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
      {isLoading ? <div>loading</div> : Embeded }
      <mentionAutocomplete.AutocompleteList/>
      <hashtagAutocomplete.AutocompleteList/>
    </div>);
};

export default Editor;