import { Dispatch, SetStateAction, useEffect } from "react";
import { onImagePaste } from "../http/Http";

export function usePasteImage(setUrlImage:Dispatch<SetStateAction<string>>) {
    useEffect(() => {
        const onPaste = async (event: ClipboardEvent) => {
            const items = event.clipboardData?.items
            if (!items) return
            for (const item of items) {
                if (item.type.startsWith("image/")) {
                    event.preventDefault()
                    const file = item.getAsFile()
                    if (!file) return
                    if (onImagePaste) {
                        await onImagePaste(file)
                        setUrlImage('/bff/getImage/' + file.name)
                    }
                    return
                }
            }
        }
        window.addEventListener("paste", onPaste)
        return () => {
        window.removeEventListener("paste", onPaste)
        };
    }, []);
}