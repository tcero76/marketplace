'use client'

import { memo, useRef } from "react";
import { EditorProps } from "@/types";
import { usePasteImage } from "@/hooks/usePasteImage";
import useFormatText from "@/hooks/useFormatText";

const Editor = memo<EditorProps>(({ onChangePosteo, onKeyUp, posteo, ...props }) => {
  const editorRef = useRef<HTMLDivElement>(null);
  const { imageUrl, isLoading } = usePasteImage(editorRef.current);
  const { onInput, Embeded } =
    useFormatText({
      onChangePosteo,
      editorRef,
      imageUrl,
      posteo
    })
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
          {isLoading ? <div>loading</div> : Embeded }
      </>);
});

export default Editor;