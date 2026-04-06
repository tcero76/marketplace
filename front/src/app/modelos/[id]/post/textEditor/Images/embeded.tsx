import { useRef, useState, useEffect } from 'react';
import { EmbededProps } from '@/types';
import { useOnEmbedQuery } from '@/http/api';

const EmbededComponent = ({imageUrl, urlEmbeded}:EmbededProps) => {
  const [urlImage, setUrlImage] = useState<string>('');
  const refImg = useRef<HTMLImageElement | null>(null)
  const { data } = useOnEmbedQuery(urlEmbeded ?? "", { skip: !urlEmbeded })
    useEffect(() => {
        if (!!imageUrl) {
            setUrlImage(imageUrl);
        }   
    },[imageUrl])
    useEffect(() => {
        if (data?.thumbnail) setUrlImage(data.thumbnail);
    },[data])
    return (
    <div className="image-wrapper">
        {urlImage!='' && <><img src={urlImage} className="preview" ref={refImg}/>
        <button
            className="remove-btn"
            onClick={() => setUrlImage("")}
            aria-label="Eliminar imagen"
        >
            ×
        </button></>}
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

export default EmbededComponent;