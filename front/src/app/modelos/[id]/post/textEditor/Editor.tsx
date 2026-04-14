'use client'

import { FC, useRef } from "react";
import { PosteoRaw, type EditorProps, type Posteo } from "@/types";
import { usePasteImage } from "@/hooks/usePasteImage";
import useFormatText from "@/hooks/useFormatText";
import { useAutocomplete } from '@/hooks/useAutocomplete';
import { useGetTsesQuery, useGetTopicsQuery } from '@/http/api';
import enrichMeta from "@/lib/meta/enrichMeta";

const Editor:FC<EditorProps> = ({ onChangePosteo, posteo, ...props }) => {
  const { data:tses } = useGetTsesQuery()
  const { data:topics } = useGetTopicsQuery()
  const handleChangePosteo = (posteoRaw: PosteoRaw) => {
    const meta = enrichMeta(
      posteoRaw.metaRaw,
      tses ?? [],
      topics ?? []
    );
    onChangePosteo({
      ...posteoRaw,
      meta
    });
  };
  const editorRef = useRef<HTMLDivElement>(null);
  const { imageUrl, isLoading } = usePasteImage(editorRef);
  const hashtagAutocomplete = useAutocomplete({ trigger: '#', categories: topics?.map(t => t.nombre) ?? [] });
  const mentionAutocomplete = useAutocomplete({ trigger: '@', categories: tses?.map(t =>  t.nombre ) ?? [] });
  const { onInput, Embeded } = useFormatText({
    onChangePosteo:handleChangePosteo,
    editorRef,
    imageUrl,
    posteo
  })
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