import { useEffect, useState } from "react";
import getUserApi from "../http/HttpFactory";
import { PasteImageResult } from "../types";

export function usePasteImage(input:HTMLDivElement | null):PasteImageResult {
    const [imageUrl, setImageUrl] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    useEffect(() => {
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
                    getUserApi()
                        .onImagePaste(file)
                        .then(res => {
                            const imgFile = process.env.NEXT_PUBLIC_MOCK === "true"? '/src/assets/Coltrane.jpg' : `/bff/getImage/${res.data.name}`
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
        if(!input) return;
        input.addEventListener("paste", onPaste as EventListener)
        return () => {
            input.removeEventListener("paste", onPaste as EventListener)
        };
    }, [input]);
    return { imageUrl, isLoading, error };
}