import { useEffect, useRef, useState } from 'react'
import TextEditor from './textEditor/TextEditor';
import { TOAST_TYPES, type Posteo } from '../../types';
import getUserApi from './../../http/HttpFactory';
import { AxiosResponse } from 'axios';
import { useParams } from 'react-router';
import Button from '../../components/buttons/Button';
import ModalHtml, { ModalHtmlHandle } from '../../components/modal/ModalHtml';
import { useUIContext } from '../../context/UIContext';

const CreatePost = () => {
    const { modelo } = useParams(); 
    const uiContext = useUIContext();
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
        refModal.current?.open()
    }
    return (
        <>
            <ModalHtml onClickModal={onClickPosteo} ref={refModal}>
                <TextEditor onChangePosteo={(p) => refPosteo.current = p}/>
            </ModalHtml>
            <div>
                <Button btnType="primary" label="Postear" onClick={onClickAbrirPost}/>
            </div>
            <div className="list-group">
            {posteos.map((p,idx) => {
                return (
                    <li key={idx} className="list-group-item">
                        <div className="card" style={{width: "18rem;"}}>
                            {p.menciones.map((m, i) => <span key={i} className="badge text-bg-secondary me-1">{m}</span>)}
                            <div className="card-body">
                                <p>{p.texto}</p>
                            </div>
                        </div>
                    </li>
                )
            })}
            </div>
        </>
    )
}
export default CreatePost