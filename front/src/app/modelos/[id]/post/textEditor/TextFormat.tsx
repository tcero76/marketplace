'use client'

import { FC } from 'react'
import { type TextFormatProps, } from '@/types';
import { useAutocomplete } from '@/hooks/useAutocomplete';
import { useGetTsesQuery, useGetTopicsQuery } from '@/http/api';
import Editor from './Editor';

const TextFormat:FC<TextFormatProps> = ({ onChangePosteo, posteo, ...props}:TextFormatProps) => {
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
      <div className="wrapper">
        <Editor
          onChangePosteo={onChangePosteo}
          posteo={posteo}
          onKeyUp={(e) => onKeyUp(e)}
          {...props}
        />
        <mentionAutocomplete.AutocompleteList/>
        <hashtagAutocomplete.AutocompleteList/>
      </div>
      );
}

export default TextFormat