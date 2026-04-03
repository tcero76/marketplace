'use client'

import { useRef } from 'react'
import {
  EditorHandle,
  type TextAndPos,
  type TextFormatProps,
  type TextFormatType } from '@/types';
import { useAutocomplete } from '@/hooks/useAutocomplete';
import Editor from './Editor';
import { useGetTsesQuery,
  useGetTopicsQuery } from '@/http/api';

const TextFormat = ({
  onChangePosteo, text, ...props}:TextFormatProps) => {
  const { data:topics } = useGetTopicsQuery()
  const hashtagAutocomplete = useAutocomplete({
      trigger: '#',
      categories: topics ?? []
    });
  const { data:tses } = useGetTsesQuery()
  const mentionAutocomplete = useAutocomplete({
      trigger: '@',
      categories: tses?.map(t =>  t.nombre ) ?? []
    });
  const onKeyUp = (e: React.KeyboardEvent<HTMLDivElement>) => {
    mentionAutocomplete.onKey(e);
    hashtagAutocomplete.onKey(e);
  }
    return (
      <div className="wrapper">
        <Editor
          onChangePosteo={onChangePosteo}
          text={text}
          onKeyUp={(e) => onKeyUp(e)}
          {...props}
        />
        <mentionAutocomplete.AutocompleteList/>
      </div>
      );
}

export default TextFormat