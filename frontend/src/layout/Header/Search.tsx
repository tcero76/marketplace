import { useRef, useState } from 'react'
import Button from '../../components/buttons/Button';
import { useRouter } from 'next/navigation'
import { useGlobalKeyboard } from '../../hooks/useKeyboardListener';
import { Input } from '@/components/ui/input';

const Search = () => {
    const router = useRouter();
    useGlobalKeyboard({
        FocusSearch: () => {
          inputRef.current?.focus();
        },
      }, { "Control+k": "FocusSearch" });
    const inputRef = useRef<HTMLInputElement>(null);
    const [ textInput, setTextInput ] = useState<string>('')
    const onChangeSearch = (e:React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        e.preventDefault();
        const words = textInput.split(/\s+/);
        const mention = words.find((w) => w.startsWith("@")) || "";
        const text:string[] = words.filter((w) => w !== mention);
        const params = new URLSearchParams();
        if (mention) params.append("mention", mention);
        if (text.length > 0) params.append("text", text.join(" "));
        router.push(`/home/search?${params.toString()}`);
    }
    return (
        <form className="d-flex me-2" role="search">
            <Input id="input-demo-api-key" type="search" ref={inputRef}
                onChange={e => setTextInput(e.target.value)}
                placeholder="Ctrl+k" />
            <Button type="submit" label="Buscar" style={{ display: 'none'}}
                btnType="outline-primary"
                onClick={onChangeSearch}/>
        </form>
    )
}
export default Search