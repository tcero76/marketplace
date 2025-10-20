import {} from 'react'
import { VideoPlayer } from '../VideoPlayer.tsx';
import SimpleChat from './SimpleChat.tsx';
import { useAuthSelector } from '../../../store/hooks.tsx';

const Chat = () => {
  const { userId, nombre } = useAuthSelector((state) => state.auth)
    return (
      <div className="container text-center">
        <div className="row"><h1>Chat</h1></div>
        <div>{nombre}</div>
        <div className="row">
          <div className="col">
          <SimpleChat/>
          </div>
          <div className="col">
          <VideoPlayer src={userId.length>0?`/live/${userId}/index.m3u8`:''}/>
          </div>
        </div>
      </div>)
}

export default Chat;