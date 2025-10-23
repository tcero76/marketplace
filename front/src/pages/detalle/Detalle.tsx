import { useEffect, useState } from 'react'
import SimpleChat from './chat/SimpleChat'
import Pago from './Pago'
import { VideoPlayer } from './VideoPlayer'
import CreatePost from './post/CreatePost'
import { useParams } from 'react-router'
import getUserApi from '../../http/HttpFactory'
import { Modelo } from '../../types'


const initModelo:Modelo = { descripcion: '', modelo: '', id: 0, fecharegistro: new Date(), idJob: 0, idModelos: 0, url: ''}
const Detalle = () => {
  const [ modeloState, setModeloState ] = useState<Modelo>(initModelo);
  const { modelo } = useParams<{ modelo: string }>();
  useEffect(() => {
    getUserApi().getModelo(modelo || '')
      .then((res) => {
        setModeloState(res.data);
    })
  },[])
    return (
    <div className="container py-4">
      <h1>{modeloState.modelo}</h1>
      <p>{modeloState.descripcion}</p>
    {/* <div className="row mb-3">
      <div className="col bg-primary text-white p-3 rounded">
        <VideoPlayer/>
      </div>
      <div className="col bg-success text-white p-3 rounded">
        <SimpleChat/>
      </div>
    </div>
    <div className="row">
      <div className="col bg-warning p-3 rounded">
        <Pago/>
      </div>
    </div> */}
    <div className="row">
      <div className="col p-3 rounded">
        <CreatePost/>
      </div>
    </div>
  </div>
      )
}
export default Detalle