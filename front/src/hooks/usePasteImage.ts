import { RefObject, useEffect, useState } from "react";
import { PasteImageResult } from "../types";
import { useOnImagePasteMutation } from "@/http/api";

export function usePasteImage(editorRef:RefObject<HTMLDivElement | null>):PasteImageResult {
    const [imageUrl, setImageUrl] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [ trigger ] = useOnImagePasteMutation()
    useEffect(() => {
        const editor = editorRef.current;
        if (!editor) return;
        const onPaste = (event: ClipboardEvent) => {
            const items = event.clipboardData?.items
            if (!items) return
            for (const item of items) {
                if (item.type.startsWith("image/")) {
                    event.preventDefault()
                    const file = item.getAsFile()
                    if (!file) return;
                    setIsLoading(true);
                    setError(null);
                    setImageUrl(null);
                    trigger(file).unwrap()
                        .then(res => {
                            const imgFile = process.env.NEXT_PUBLIC_MOCK === "true"? '/src/assets/Coltrane.jpg' : `/bff/getImage/${res.filename}`
                            setImageUrl(imgFile);
                        })
                        .catch(err => {
                            setError("Error al subir la imagen");
                            console.error("Error al subir la imagen:", err);
                        })
                        .finally(() => {
                            setIsLoading(false);
                        });
                    return
                }
            }
        }
        if(!editorRef) return;
        editor?.addEventListener("paste", onPaste as EventListener)
        return () => {
            editor?.removeEventListener("paste", onPaste as EventListener)
        };
    }, [editorRef.current]);
    return { imageUrl, isLoading, error };
}