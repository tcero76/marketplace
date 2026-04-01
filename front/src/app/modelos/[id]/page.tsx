'use client'

import { useEffect, useState } from 'react'
import SimpleChat from './chat/SimpleChat'
// import Pago from './Pago'
import { VideoPlayer } from '../VideoPlayer'
import CreatePost from './post/CreatePost'
import { useParams } from 'next/navigation'
import { Modelo } from '../../../types'
import { publishWebRTCOffer } from '../webRTC'
import { useGetTsQuery } from '@/http/api'
import { useUIContext } from '@/context/UIContext'

const initModelo:Modelo = {
  descripcion: '',
  modelo: '', id: 0,
  fecharegistro: new Date(),
  idJob: 0,
  idModelos: 0
}

const Page = () => {
  const uiContext = useUIContext()
  const params = useParams() 
  const modelo = params.id as string
  const [accessToken, setAcessToken] = useState<string>('');
  const src = `${process.env.NEXT_PUBLIC_HOST}/hls/streams/index.m3u8`
  const { data, isLoading } = useGetTsQuery(modelo)
  // const pcRef = useRef<RTCPeerConnection>(new RTCPeerConnection());
  useEffect(() => {
    if (isLoading) {
        uiContext.showSpinner();
    } else {
        uiContext.hideSpinner();
    }
    return () => {
        uiContext.hideSpinner();
    };
  }, [isLoading, uiContext]);
  useEffect(() => {
    let isMounted = true;
    async function initWebRTC() {
      try {
        pcRef.current = new RTCPeerConnection();
        const res = await fetch(`${process.env.NEXT_PUBLIC_HOST}/bff/token`, { method: "POST" });
        const jwt = (await res.json()).access_token;
        setAcessToken(jwt);
        if (!isMounted) return;

        await publishWebRTCOffer(jwt, pcRef.current);
      } catch (err) {
        console.error("WebRTC error:", err);
      }
    }
    // initWebRTC();
    // getUserApi().getModelo(modelo || '')
    //   .then((res) => {
    //     setModeloState(res.data);
    // })
    //   return () => {
    //     if (pcRef.current) {
    //       isMounted = false;
    //       pcRef.current.close();
    //     }
    //   };
  },[])
    return (
    <div className="container mx-auto px-4 py-6 max-w-7xl">
      <div className="mb-6">
        <h1 className="text-3xl font-bold tracking-tight sm:text-4xl">
          {data?.nombre || 'Modelo'}
        </h1>
        <p className="mt-3 text-lg text-gray-600 dark:text-gray-400">
          {data?.descripcion || 'Descripción del modelo...'}
        </p>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div className="bg-gray-900 rounded-xl overflow-hidden shadow-lg border border-gray-800">
          <div className="aspect-video">
          {/* { modelo!=undefined && <VideoPlayer src={src} accessToken={accessToken}/>} */}
            <div className="h-full flex items-center justify-center text-gray-500">
              Área del reproductor de video
            </div>
          </div>
        </div>
        <div className="rounded-lg bg-gray-800/50 p-4 border border-gray-700 shadow-sm">
          <SimpleChat roomName={modelo}/>
        </div>
      </div>
      <div className="mb-8">
        <div className="bg-yellow-500/20 border border-yellow-500/30 rounded-xl p-6 text-center shadow-sm">
          {/* <Pago/> */}
          <p className="text-yellow-800 font-medium">Sección de pago / monetización (componente pendiente)</p>
        </div>
      </div>
        <div className="bg-gray-800/30 rounded-xl p-6 border border-gray-700 shadow-sm">
          <CreatePost nombre={data?.nombre}/>
        </div>
    </div>
      )
}
export default Page