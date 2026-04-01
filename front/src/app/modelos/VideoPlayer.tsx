import { useEffect, useRef } from 'react';
import Hls from 'hls.js'

interface HlsPlayerProps {
    src: string;
    autoPlay?: boolean;
    controls?: boolean;
    muted?: boolean;
    className?: string;
    accessToken: string;
  }

export const VideoPlayer:React.FC<HlsPlayerProps> = ({
    src,
    autoPlay = true,
    controls = false,
    muted = true,
    className = '',
    accessToken
  }) => {
    const videoRef = useRef<HTMLVideoElement>(document.createElement('video'))
    useEffect(() => {
    window.setTimeout(() => {
        const video = videoRef.current;
        if (!video) return;
        if(Hls.isSupported()) {
            const hls = new Hls({
              xhrSetup: (xhr, _url) => {
                xhr.setRequestHeader("Authorization", `Bearer ${accessToken}`); 
              }
            });
            hls.loadSource(src);
            hls.attachMedia(video);
            hls.on(Hls.Events.ERROR, (_event, data) => {
                console.error('HLS error:', data);
              });
            return () =>  hls.destroy()
        } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
            video.src = src;
        }
    }, 1500);
    },[src,accessToken])
    return <>{(src.length>0)?<video
            ref={videoRef}
            className={className}
            autoPlay={autoPlay}
            controls={controls}
            muted={muted}
            style={{ width: '100%', maxWidth: '720px' }}
            ></video>:<></>}
          </>
}