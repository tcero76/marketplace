import { useRef, useState } from 'react'
import Button from '../../components/buttons/Button';
import { useGlobalKeyboard } from '../../store/useKeyboardListener';
import { useNavigate } from 'react-router';

const Search = () => {
    const navigate = useNavigate()
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
        navigate("/home", { state: { mention, text } });
    }
    return (
        <form className="d-flex me-2" role="search">
            <input className="form-control" ref={inputRef}
                type="search" placeholder="Ctrl+k"
                aria-label="Search"
                value={textInput}
                onChange={e => setTextInput(e.target.value)}/>
            <Button type="submit" label="Buscar"
                btnType="outline-primary"
                onClick={onChangeSearch}/>
        </form>
    )
}
export default Search