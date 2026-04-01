import { useRef, useState } from 'react'
import { useParams } from 'next/navigation'
import TextEditor from './textEditor/TextEditor';
import { ModalHtmlHandle, TextEditorType, TOAST_TYPES, type Posteo } from '../../../../types';
import ModalHtml from '@/components/modal/ModalHtml';
import { useUIContext } from '@/context/UIContext';
import { Button } from '@/components/ui/button';
import { Item, ItemActions, ItemContent, ItemDescription, ItemMedia, ItemTitle } from '@/components/ui/item';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { useGetPosteosQuery, useSendPostMutation } from '@/http/api';

type CreatePostProps = {
  nombre: string
}
const CreatePost = ({ nombre }:CreatePostProps) => {
    const [open, setOpen] = useState<boolean>(false);
    const refTextEditor = useRef<TextEditorType>(null);
    const refPosteo = useRef<Posteo | null>(null);
    const refModal = useRef<ModalHtmlHandle>(null);
    const { data:posteos } = useGetPosteosQuery(nombre)
    const [ trigger ] = useSendPostMutation()
    const uiContext = useUIContext();
    const onClickPosteo = () => {
        if(!refPosteo.current) return;
        trigger(refPosteo.current).unwrap()
        .then(() => {
            uiContext.showSpinner()
            uiContext.showToast({msg:"Enviado", type:TOAST_TYPES.SUCCESS})
            refModal.current?.close()
        })
        .finally(() => {
            uiContext.hideSpinner()
        })
    }
    const onClickAbrirPost = () => {
        refTextEditor.current?.cleanInput()
        setOpen(true)
    }
    const onEditar = (posteo:Posteo) => {
        refTextEditor.current?.setPosteo(posteo)
        setOpen(true)
    }
    if(!posteos) return <div>Sin posteos....</div>
    return (
        <>
            <ModalHtml onClickModal={onClickPosteo}
                open={open}
                setOpen={setOpen}
                ref={refModal}
                iconBtnAccept='send'>
                <TextEditor onChangePosteo={(p) => refPosteo.current = p} ref={refTextEditor}/>
            </ModalHtml>
            <Button onClick={onClickAbrirPost}>Postear</Button>
            <div className="w-full space-y-4">
                {posteos.map((p,idx) => {
                    return (
                        <Item variant="outline" key={idx}>
                            <ItemMedia>
                            <Avatar className="size-10">
                                <AvatarImage src="https://github.com/evilrabbit.png" />
                                <AvatarFallback>ER</AvatarFallback>
                            </Avatar>
                            </ItemMedia>
                            <ItemContent>
                                <ItemTitle>{p.userId}</ItemTitle>
                                <ItemDescription>{p.texto}</ItemDescription>
                            </ItemContent>
                            <ItemActions>
                                <Button size="sm"
                                    variant="outline"
                                    onClick={() => onEditar(p)}>
                                    Editar
                                </Button>
                            </ItemActions>
                        </Item>
                    )
                })}
            </div>
        </>
    )
}
export default CreatePost