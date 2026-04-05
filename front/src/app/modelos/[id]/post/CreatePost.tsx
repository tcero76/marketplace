import { useRef, useState } from 'react'
import { ModalHtmlHandle, TOAST_TYPES, type Posteo } from '../../../../types';
import ModalHtml from '@/components/modal/ModalHtml';
import { useUIContext } from '@/context/UIContext';
import { Button } from '@/components/ui/button';
import { Item, ItemActions, ItemContent, ItemDescription, ItemMedia, ItemTitle } from '@/components/ui/item';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { useGetPosteosQuery, useSendPostMutation } from '@/http/api';
import TextFormat from './textEditor/TextFormat';

type CreatePostProps = {
  nombre: string
}
const CreatePost = ({ nombre }:CreatePostProps) => {
    const [modal, setModal] = useState<{open:boolean, text:string}>(false);
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
        setModal({open:true, text:""})
    }
    const onEditar = (posteo:Posteo) => {
        setModal({open:true, text:posteo.texto})
    }
    if(!posteos) return <div>Sin posteos....</div>
    return (
        <>
            <ModalHtml onClickModal={onClickPosteo}
                open={modal.open}
                setOpen={() => setModal({open:false, text:""})}
                ref={refModal}
                iconBtnAccept='send'>
                <TextFormat onChangePosteo={(p) => refPosteo.current = p} text={modal.text}/>
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