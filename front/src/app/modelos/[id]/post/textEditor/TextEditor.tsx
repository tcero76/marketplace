'use client'

import { FC } from 'react';
import TextFormat from './TextFormat';
import { type TextEditorProps,
  type TextFormatType } from '@/types/index';

const initialTextEditorState: TextFormatType = {
  cleanInput:() => null,
  setInput:(texto:string) => null,
  getInput:() => null
}
const TextEditor:FC<TextEditorProps> = ({
  onChangePosteo, text, ...props}:TextEditorProps) => {
  return <TextFormat
            onChangePosteo={onChangePosteo}
            text={text}
            { ...props }
          />
};

export default TextEditor;