import { useRef } from 'react'
import { useRouter } from 'next/navigation'
import { useGlobalKeyboard } from '../../hooks/useKeyboardListener';
import { useGetTopicsQuery, useGetTsesQuery } from '@/http/api';
import { useAutocomplete } from '@/hooks/useAutocomplete';
import { restoreCaretPosition, storeCaretPosition } from '@/utils/caret';
import { composeHighlighters } from '@/utils/highlights/composeHighlighters';
import { arrobaHighlighter, hashtagHighlighter } from '@/utils/highlights/highlighters';
import enrichMeta from '@/lib/meta/enrichMeta';

const Search = () => {
    const { data:topics } = useGetTopicsQuery()
    const { data:tses } = useGetTsesQuery()
    const mentionAutocomplete = useAutocomplete({ trigger: '@', categories: tses?.map(t =>  t.nombre ) ?? [] });
    const hashtagAutocomplete = useAutocomplete({ trigger: '#', categories: topics?.map(t => t.nombre) ?? [] });
    const router = useRouter();
    useGlobalKeyboard({
        FocusSearch: () => {
          inputRef.current?.focus();
        },
      }, { "Control+k": "FocusSearch" });
    const inputRef = useRef<HTMLDivElement>(null);

    const highlight =  (texto:string) => {
        const { metaRaw, cleanText } = composeHighlighters(
            hashtagHighlighter,
            arrobaHighlighter)(texto);
        return { cleanText , metaRaw };
    }
    const onChangeSearch = (e:React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        e.preventDefault();
        const { cleanText, metaRaw } = highlight(inputRef.current?.innerText || '')
        const meta = enrichMeta(metaRaw, tses ?? [], topics ?? [])
        const params = new URLSearchParams();
        meta.mentions?.forEach(m => params.append("mention", m.nombre));
        meta.hashtags?.forEach(m => params.append("hashtag", m.id.toString()));
        if (cleanText.length > 0) params.append("text", cleanText);
        router.push(`/home/search?${params.toString()}`);
    }
    const onKeyUp = (e: React.KeyboardEvent<HTMLDivElement>) => {
            hashtagAutocomplete.onKey(e);
            mentionAutocomplete.onKey(e);
        if(e.key === "Enter") {
            onChangeSearch(e as any)
        }
    }
    const onInput = async (ev: React.FormEvent<HTMLDivElement>) => {
        const editor = inputRef.current;
        if(!editor) return
        const native = ev.nativeEvent as InputEvent;
        const inputType = native.inputType;
        if(inputType === 'insertCompositionText' || inputType === 'deleteCompositionText') return
        const pos = storeCaretPosition(editor)
        editor.innerHTML = editor.innerText
        restoreCaretPosition(editor, pos);
    };
    return (
        <>
            <div
                onInput={onInput}
                onKeyUp={onKeyUp}
                contentEditable
                className="min-w-[150px] w-full
                            px-5 py-1
                            bg-zinc-50 dark:bg-zinc-950
                            border border-zinc-200 dark:border-zinc-800
                            rounded-md
                            text-[17px] leading-relaxed
                            text-zinc-900 dark:text-zinc-100
                            placeholder-zinc-400
                            focus:outline-none 
                            focus:border-blue-500 dark:focus:border-blue-600
                            focus:ring-2 focus:ring-blue-500/20
                            transition-all duration-300
                            empty:before:content-[attr(data-placeholder)]
                            empty:before:text-zinc-400 dark:empty:before:text-zinc-500
                            empty:before:select-none"
                data-placeholder="Ctrl+k para buscar..."
                suppressContentEditableWarning
                ref={inputRef}/>
            <hashtagAutocomplete.AutocompleteList/>
            <mentionAutocomplete.AutocompleteList/>
            </>
    )
}
export default Search