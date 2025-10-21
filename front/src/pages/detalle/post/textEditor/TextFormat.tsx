import { useRef, useState, useEffect, useImperativeHandle, ForwardedRef, forwardRef } from 'react'
import getUserApi from '../../../../http/HttpFactory';
import { AxiosResponse } from 'axios';
import {
  type TextAndPos,
  type TextFormatProps,
  type TextFormatType } from '../../../../types';

const storeCaretPosition = (editor:HTMLDivElement):number => {
    const selection = window.getSelection();
    if (!selection) return;
    if (!selection.rangeCount) return;
    const range = selection.getRangeAt(0);
    const preCaretRange = range.cloneRange();
    preCaretRange.selectNodeContents(editor);
    preCaretRange.setEnd(range.endContainer, range.endOffset);
    return preCaretRange.toString().length;
}
const restoreCaretPosition = (element:HTMLDivElement, offset:number) => {
    const selection = window.getSelection();
    const range = document.createRange();
    let currentNode = null;
    let currentOffset = 0;
    const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null);
    while (walker.nextNode()) {
      const node = walker.currentNode;
      const length = node.nodeValue.length;
      if (currentOffset + length >= offset) {
        currentNode = node;
        break;
      }
      currentOffset += length;
    }
    if (currentNode) {
      range.setStart(currentNode, offset - currentOffset);
      range.collapse(true);
      selection?.removeAllRanges();
      selection?.addRange(range);
    }
  };

let dictionary:string[] = [];
const TextFormat = forwardRef<TextFormatType,TextFormatProps>(({ highlight, ...props}:TextFormatProps , ref:ForwardedRef<TextFormatType>) => {
  const [textAndPos, setTextAndPos ] = useState<TextAndPos>({text:'', pos: 0})
  const editorRef = useRef<HTMLDivElement>(document.createElement('div'));
  const suggestionsRef = useRef<HTMLUListElement>(document.createElement('ul'));
  useImperativeHandle(ref,() => ({
    cleanInput:() => {
      setTextAndPos({text:'', pos:0})
    },
    setInput:(text:string) => {
      setTextAndPos({text, pos:text.length})
    }
  }))

  function getCaretCoordinates(range: Range): DOMRect {
    let rect = range.getBoundingClientRect();
    if (rect.x === 0 && rect.y === 0) {
      // Insertar marcador temporal
      const marker = document.createElement("span");
      marker.textContent = "\u200b"; // carácter invisible
      range.insertNode(marker);
      rect = marker.getBoundingClientRect();
      marker.remove();
    }
    return rect;
  }

  function showSuggestions(options: string[], range: Range) {
    suggestionsRef.current.innerHTML = "";
    options.forEach((opt) => {
      const li = document.createElement("li");
      li.classList.add("list-group-item", "list-group-item-action");
      li.textContent = opt;
      li.addEventListener("click", () => {
        insertSuggestion(opt, range);
        suggestionsRef.current.classList.add("d-none");
      });
      suggestionsRef.current.appendChild(li);
    });
    // Calcula la posición exacta del caret
    const rect = getCaretCoordinates(range);
    suggestionsRef.current.style.left = rect.left + "px";
    suggestionsRef.current.style.top = rect.bottom + "px";
    suggestionsRef.current.classList.remove("d-none");
  }

  function insertSuggestion(word: string, range: Range) {
    const textNode = range.startContainer;
    const text = textNode.textContent ?? "";
    const before = text.slice(0, range.startOffset).replace(/#\w*$/, word);
    const after = text.slice(range.startOffset);
    textNode.textContent = before + after;
    const sel = window.getSelection();
    const newRange = document.createRange();
    newRange.setStart(textNode, before.length);
    newRange.collapse(true);
    sel?.removeAllRanges();
    sel?.addRange(newRange);
  }

  useEffect(() => {
      getUserApi().getModelos()
      .then((res:AxiosResponse<string[]>) => {
        dictionary = res.data.map(m => `#${m}`);
      })
  })

  useEffect(() => {
    const editor = editorRef.current;
    editor.innerHTML = highlight(editor.innerText)
    restoreCaretPosition(editor, textAndPos.pos);
  },[textAndPos])

  const onKey = () => {
    const sel = window.getSelection();
    if (!sel || sel.rangeCount === 0) return;
    const range = sel.getRangeAt(0);
    const textBeforeCaret = range.startContainer.textContent?.slice(0, range.startOffset) ?? "";
    const match = textBeforeCaret.match(/#\w*$/);
    if (match) {
      const current = match[0];
      const options = dictionary.filter((d) => d.toLowerCase().startsWith(current.toLowerCase())).slice(0, 5);;

      if (options.length > 0) {
        showSuggestions(options, range);
      } else {
        suggestionsRef.current.classList.add("d-none");
      }
    } else {
        suggestionsRef.current.classList.add("d-none");
    }
  }

  const handleChange = async () => {
    const editor = editorRef.current;
    const tP = {
      text:editor.innerText, pos:storeCaretPosition(editor)
    }
    setTextAndPos(tP)
  };
    return (
        <div>
          <div
            spellCheck="false"
            className="form-control"
            ref={editorRef}
            contentEditable
            onKeyUp={onKey}
            onInput={handleChange}
            dangerouslySetInnerHTML={{ __html: textAndPos.text}}
            style={{ padding: '10px', minHeight: '100px' }}
            {...props}
          />
        <ul id="suggestions" className="list-group suggestions d-none" ref={suggestionsRef}></ul>
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
            `}</style>
        </div>
      );
})

export default TextFormat