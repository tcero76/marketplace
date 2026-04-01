import { useImperativeHandle, useRef, useState, forwardRef, ForwardedRef, useEffect } from 'react';
import { EmbededHandle, EmbededProps, EmbededType } from '@/types';
import getUserApi from '@/http/HttpFactory';

const Embeded = forwardRef<EmbededHandle,EmbededProps>(({imageUrl}:EmbededProps, ref:ForwardedRef<EmbededHandle>) => {
  const [urlImage, setUrlImage] = useState<string>('');
  const refImg = useRef<HTMLImageElement | null>(null)
  useImperativeHandle(ref, () => ({
    setUrls: (urls:string[]) => {
        if(!urls[0]) return 
        getUserApi().onEmbed(urls[0])
        .then(res => {
            const data = res.data as EmbededType
            setUrlImage(data.thumbnail)
        })
        .catch(err => {
            console.error("Error al obtener el embed:", err);
        });
    }
  }));
  useEffect(() => {
    if (!imageUrl) return
      setUrlImage(imageUrl);
  }, [imageUrl]);
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
})

export default Embeded;