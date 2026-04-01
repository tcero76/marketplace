'use client'

import { useRef,
  useState,
  useImperativeHandle,
  ForwardedRef,
  forwardRef } from 'react'
import {
  type TextAndPos,
  type TextFormatProps,
  type TextFormatType } from '@/types';
import { useAutocomplete } from '@/hooks/useAutocomplete';
import Editor from './Editor';
import { useGetTsesQuery,
  useGetTopicsQuery } from '@/http/api';

const TextFormat = forwardRef<TextFormatType,TextFormatProps>(({
  onChangePosteo, ...props}:TextFormatProps,
  ref:ForwardedRef<TextFormatType>) => {
  const [textAndPos, setTextAndPos ] = useState<TextAndPos>({text:'', pos: 0})
  const editorRef = useRef<HTMLDivElement>(null);
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
  useImperativeHandle(ref,() => ({
    cleanInput:() => {
      setTextAndPos({ text:'', pos:0 })
    },
    setInput:(text:string) => {
      setTextAndPos({text, pos:text.length})
    },
    getInput:():HTMLDivElement => {
      return editorRef.current
    } 
  }))
  const onKeyUp = (e: React.KeyboardEvent<HTMLDivElement>) => {
    mentionAutocomplete.onKey(e);
    hashtagAutocomplete.onKey(e);

  }
    return (
      <div className="wrapper">
        <Editor
          onChangePosteo={onChangePosteo}
          editorRef={editorRef}
          onKeyUp={(e) => onKeyUp(e)}
          {...props}
        />
        <mentionAutocomplete.AutocompleteList/>
      </div>
      );
})

export default TextFormat