import {  useRef, useState } from 'react';
import { usePasteImage } from '../../../../../hooks/usePasteImage';

const Embeded = () => {
  const [urlImage, setUrlImage] = useState<string>('');
  const ref = useRef<HTMLImageElement | null>(null)
  usePasteImage(setUrlImage);
    return (
    <div className="image-wrapper">
            <img src={urlImage} className="preview" ref={ref}/>
           {urlImage!='' && <button
                className="remove-btn"
                onClick={() => setUrlImage("")}
                aria-label="Eliminar imagen"
            >
                ×
            </button>}
            <style>{`
            .wrapper {
                width: 400px;
                border: 1px solid #ccc;
            }
        .image-wrapper {
          position: relative;
          width: 100%;
          max-width: 400px;
        }
            .editor {
                padding: 10px;
                min-height: 100px;
                width: 100%;
                box-sizing: border-box;
            }
            .preview {
                width: 100%;
                height: auto;
                display: block;
            }

            .remove-btn {
            position: absolute;
            top: 6px;
            right: 6px;
            width: 24px;
            height: 24px;
            border: none;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            font-size: 16px;
            cursor: pointer;
            line-height: 24px;
            padding: 0;
            }

            .remove-btn:hover {
            background: rgba(0, 0, 0, 0.8);
            }
            `}</style>
        </div>
    )
}

export default Embeded;