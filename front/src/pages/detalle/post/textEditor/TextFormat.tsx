import { useRef, useState, useEffect, useImperativeHandle, ForwardedRef, forwardRef } from 'react'
import {
  type TextAndPos,
  type TextFormatProps,
  type TextFormatType } from '../../../../types';
import { restoreCaretPosition, storeCaretPosition } from '../../../../utils/caret';
import { useAutocomplete } from '../../../../hooks/useAutocomplete';
import getUserApi from '../../../../http/HttpFactory';
import Embeded from './Images/embeded';

const TextFormat = forwardRef<TextFormatType,TextFormatProps>(({ highlight, ...props}:TextFormatProps , ref:ForwardedRef<TextFormatType>) => {
  const [textAndPos, setTextAndPos ] = useState<TextAndPos>({text:'', pos: 0})
  const editorRef = useRef<HTMLDivElement>(document.createElement('div'));
  const suggestionsRef = useRef<HTMLUListElement>(document.createElement('ul'));
  const hashtagAutocomplete = useAutocomplete(
    suggestionsRef.current, {
      trigger: '#',
      loadDictionary: () => getUserApi().getTopics().then(res => res.data.map(m => `#${m}`))
    });
  const mentionAutocomplete = useAutocomplete(
    suggestionsRef.current, {
      trigger: '@',
      loadDictionary: () => getUserApi().getModelos().then(res => res.data.map(m => `@${m}`))
    });
  useImperativeHandle(ref,() => ({
    cleanInput:() => {
      setTextAndPos({text:'', pos:0})
    },
    setInput:(text:string) => {
      setTextAndPos({text, pos:text.length})
    }
  }))
  useEffect(() => {
    const editor = editorRef.current;
    editor.innerHTML = highlight(editor.innerText)
    restoreCaretPosition(editor, textAndPos.pos);
  },[textAndPos])
  const handleChange = async (ev: React.FormEvent<HTMLDivElement>) => {
    const native = ev.nativeEvent as InputEvent;
    const inputType = native.inputType;
    if(inputType === 'insertCompositionText' || inputType === 'deleteCompositionText') return
    const editor = editorRef.current;
    const tP = {
      text:editor.innerText, pos:storeCaretPosition(editor)
    }
    setTextAndPos(tP)
  };
  const onKey = () => {
    mentionAutocomplete.onKey();
    hashtagAutocomplete.onKey();
  }
    return (
        <div className="wrapper">
          <div
            spellCheck="false"
            className="form-control"
            ref={editorRef}
            contentEditable
            onKeyUp={onKey}
            onInput={handleChange}
            dangerouslySetInnerHTML={{ __html: textAndPos.text}}
            style={{ padding: '10px', minHeight: '100px' }}
            suppressContentEditableWarning
            {...props}
          />
          <Embeded/>
        <ul id="suggestions"
          className="list-group suggestions d-none"
          ref={suggestionsRef}>
        </ul>
        <style>{`
            .highlight {
              color: blue;
              font-weight: bold;
            }
          .suggestions {
              position: fixed;
              z-index: 1000;
          }
          .suggestions li {
              cursor: pointer;
          }
          .hidden {
              display: none;
          }
          `}
        </style>
        </div>
      );
})

export default TextFormat