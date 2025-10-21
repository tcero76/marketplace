import { useEffect, useRef, useState } from 'react'
import TextEditor from './textEditor/TextEditor';
import { TextEditorType, TOAST_TYPES, type Posteo } from '../../../types';
import getUserApi from '../../../http/HttpFactory';
import { AxiosResponse } from 'axios';
import { useParams } from 'react-router';
import Button from '../../../components/buttons/Button';
import ModalHtml, { ModalHtmlHandle } from '../../../components/modal/ModalHtml';
import { useUIContext } from '../../../context/UIContext';
import Post from './Post';

const CreatePost = () => {
    const { modelo } = useParams(); 
    const uiContext = useUIContext();
    const refTextEditor = useRef<TextEditorType>(null);
    const refPosteo = useRef<Posteo>({menciones:[], texto:''});
    const refModal = useRef<ModalHtmlHandle>(null);
    const [ posteos, setPosteos ] = useState<Posteo[]>([]);
    useEffect(() => {
        getUserApi().getPosteos(modelo)
        .then((res:AxiosResponse<Posteo[]>) => {
            setPosteos(res.data)
        })
    },[])
    const onClickPosteo = () => {
        uiContext.showSpinner()
        getUserApi().sendPost(refPosteo.current)
        .then(() => {
            uiContext.showToast({msg:"Enviado", type:TOAST_TYPES.SUCCESS})
            refModal.current?.close()
        })
        .finally(() => {
            uiContext.hideSpinner()
        })
    }
    const onClickAbrirPost = () => {
        refTextEditor.current?.cleanInput()
        refModal.current?.open()
    }
    const onEditar = (posteo:Posteo) => {
        refTextEditor.current?.setPosteo(posteo)
        refModal.current?.open()
    }
    return (
        <>
            <ModalHtml onClickModal={onClickPosteo} ref={refModal} iconBtnAccept='send'>
                <TextEditor onChangePosteo={(p) => refPosteo.current = p} ref={refTextEditor}/>
            </ModalHtml>
            <Button
                btnType="primary"
                label="Postear"
                onClick={onClickAbrirPost}/>
            <div className="list-group">
                {posteos.map((p,idx) => {
                    return (
                        <li key={idx} className="list-group-item">
                            <Post index={p} editar={onEditar}/>
                        </li>
                    )
                })}
            </div>
        </>
    )
}
export default CreatePost