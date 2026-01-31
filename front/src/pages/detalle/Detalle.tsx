import { useEffect, useState, useRef } from 'react'
// import SimpleChat from './chat/SimpleChat'
// import Pago from './Pago'
import { VideoPlayer } from './VideoPlayer'
import CreatePost from './post/CreatePost'
import { useParams } from 'react-router'
import getUserApi from '../../http/HttpFactory'
import { Modelo } from '../../types'
import { publishWebRTCOffer } from './webRTC'

const initModelo:Modelo = { descripcion: '', modelo: '', id: 0, fecharegistro: new Date(), idJob: 0, idModelos: 0 }
const Detalle = () => {
  const [ modeloState, setModeloState ] = useState<Modelo>(initModelo);
  const { modelo } = useParams<{ modelo: string }>();
  const [accessToken, setAcessToken] = useState<string>('');
  const src = modelo ? `https://sugarfever.ddns.net/hls/streams/index.m3u8` : ''
  const pcRef = useRef<RTCPeerConnection>(new RTCPeerConnection());
  useEffect(() => {
    let isMounted = true;
    async function initWebRTC() {

      try {
        pcRef.current = new RTCPeerConnection();
        const res = await fetch("https://sugarfever.ddns.net/bff/token", { method: "POST" });
        const jwt = (await res.json()).access_token;
        setAcessToken(jwt);
        if (!isMounted) return;

        await publishWebRTCOffer(jwt, pcRef.current);
      } catch (err) {
        console.error("WebRTC error:", err);
      }
    }
    initWebRTC();
    getUserApi().getModelo(modelo || '')
      .then((res) => {
        setModeloState(res.data);
    })
      return () => {
        if (pcRef.current) {
          console.log("Cerrando pcRef.current de WebRTC...")
          isMounted = false;
          pcRef.current.close();
        }
      };
  },[])
    return (
    <div className="container py-4">
      <h1>{modeloState.modelo}</h1>
      <p>{modeloState.descripcion}</p>
    <div className="row mb-3">
      <div className="col bg-primary text-white p-3 rounded">
        { modelo!=undefined && <VideoPlayer src={src} accessToken={accessToken}/>}
      </div>
      {/* <div className="col bg-success text-white p-3 rounded">
        <SimpleChat/>
      </div> */}
    </div>
    <div className="row">
      {/* <div className="col bg-warning p-3 rounded">
        <Pago/>
      </div> */}
    </div>
    <div className="row">
      <div className="col p-3 rounded">
        <CreatePost/>
      </div>
    </div>
  </div>
      )
}
export default Detalle