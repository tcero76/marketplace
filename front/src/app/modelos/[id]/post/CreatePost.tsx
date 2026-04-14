import { useState } from 'react'
import { TOAST_TYPES, type Posteo } from '../../../../types';
import ModalHtml from '@/components/modal/ModalHtml';
import { useUIContext } from '@/context/UIContext';
import { Button } from '@/components/ui/button';
import { Item, ItemActions, ItemContent, ItemDescription, ItemMedia, ItemTitle } from '@/components/ui/item';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { useGetPosteosQuery, useSendPostMutation } from '@/http/api';
import TextFormat from './textEditor/TextFormat';
import Editor from './textEditor/Editor';

type CreatePostProps = {
  nombre: string
}
const CreatePost = ({ nombre }:CreatePostProps) => {
    const [modal, setModal] = useState<boolean>(false);
    const [posteo, setPosteo] = useState<Posteo | null>(null);
    const { data:posteos } = useGetPosteosQuery(nombre)
    const [ trigger ] = useSendPostMutation()
    const uiContext = useUIContext();
    const onClickPosteo = () => {
        if(!posteo) return;
        uiContext.showSpinner()
        trigger(posteo).unwrap()
        .then(() => {
            uiContext.showToast({msg:"Enviado", type:TOAST_TYPES.SUCCESS})
            setModal(false)
        })
        .finally(() => {
            uiContext.hideSpinner()
        })
    }
    const onClickAbrirPost = () => {
        const emptyPost: Posteo = {
            texto: '',
            meta:  {
                mentions: [],
                hashtags: [],
                urls: []
                },
            userId: '',
            id: ''
            };
        setPosteo(emptyPost);
        setModal(true)
    }
    const onEditar = (posteo:Posteo) => {
        setPosteo({ ...posteo });
        setModal(true)
    }
    if(!posteos) return <div>Sin posteos....</div>
    return (
        <>
            <ModalHtml onClickModal={onClickPosteo}
                open={modal}
                setOpen={setModal}
                iconBtnAccept='send'>
                <Editor
                    onChangePosteo={setPosteo}
                    posteo={posteo}/>
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
                                <ItemTitle>{p.id}</ItemTitle>
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