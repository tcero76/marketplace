'use client'

import { FC, useState, FormEvent, useEffect, useRef } from 'react';
import { Socket, Channel } from 'phoenix';
import { type SimpleChatProps, type Message } from '../../../../types'
import { useAuthSelector } from '../../../../store/hooks';
import Button from '../../../../components/buttons/Button';
import { Presence } from 'phoenix';
// import { usePasteImage } from '../../../hooks/usePasteImage.ts';

const SimpleChat: FC<SimpleChatProps> = ({ roomName }:SimpleChatProps) => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [onlineUsers, setOnlineUsers] = useState<Array<{id:string, username:string, online_at:string}>>([]);
  const [input, setInput] = useState<string>('');
  const [socket, setSocket ] = useState<Socket>();
  const [channel, setChannel] = useState<Channel>();
  const containerRef = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null);
  const { userId } = useAuthSelector((state) => state.auth)
  const topic = `room:${roomName}`
  // const { imageUrl, isLoading } = usePasteImage(inputRef.current!);
  useEffect(() => {
    const el = containerRef.current;
    if (el) {
      el.scrollTop = el.scrollHeight;
    }
  },[messages])
  useEffect(() => {
    channel?.join()
      .receive("ok", () => {
        console.log(`Conectado al canal ${topic}`);
        setChannel(channel);
      })
      .receive("error", (resp) => {
        console.log("Error al conectar", resp);
      });
      channel?.on("message:new", (payload) => {
        setMessages((prev) => [...prev, { 
          userId:payload.userId,
          message:payload.body,
          extName: payload.extName
        }]);
      });
      if (!channel) return;
      const presence = new Presence(channel);
      presence.onSync(() => {
        const onlineUsers = presence.list((id, { metas: [first, ...rest] }) => ({
          id,
          username: first.username,
          online_at: first.online_at,
          // count: 1 + rest.length si multi-dispositivo
        }));
        console.log("Usuarios conectados:", onlineUsers);
        setOnlineUsers(onlineUsers);
      });
      return () => {
        channel?.leave();
      }
  },[channel,topic])
  useEffect(() => {
    socket?.connect()
    setChannel(socket?.channel(topic, {}));
    return () => {
      console.log("Cerrando WebSocket...");
      socket?.disconnect();
    }
  },[socket])
  useEffect(() => {
    setSocket(new Socket(`${process.env.NEXT_PUBLIC_WS}/api/socket`, { params: { token: sessionStorage.getItem("Access_Token") }}));
  },[])
  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (!input.trim()) return;
    const newMessage: Message = {
      userId,
      message: input
    };
    channel?.push("message:new", newMessage)
    setInput('');
  };
  if (!roomName) return <div>Room no válido</div>;
  return (
    <div style={styles.container}>
      <div className="row" style={{height: '100%'}}>
      <div className="col-9"
        ref={containerRef}
        style={styles.chatBox}
      >
        {messages.map((msg,idx) => (
          <div
            key={idx}
            style={{
              ...styles.message,
              alignSelf: msg.userId === userId ? 'flex-end' : 'flex-start',
              backgroundColor: msg.userId === userId ? '#DCF8C6' : '#EEE',padding: '8px 12px',
              borderRadius: 12,
              maxWidth: '75%',
              display: 'flex',
              flexDirection: 'column',
              gap: 2,
            }}
          >
            {msg.userId !== userId && msg.userId && (
              <span
                style={{
                  fontSize: '0.78em',
                  fontWeight: 600,
                  color: '#444',
                  opacity: 0.9,
                  alignSelf: 'flex-start',
                }}
              >
                {msg.extName}:
              </span>
            )}
            {msg.message}
          </div>
        ))}
      </div>
      <div className="col-3">
        {onlineUsers.map((u) => {
          return <li>{u.username}</li>
        })}
      </div>
      </div>
      <form onSubmit={handleSubmit} style={styles.inputForm}>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Escribe un mensaje..."
          style={styles.input}
          ref={inputRef}
        />
        <Button type="submit"  btnType="primary" label="Enviar"/>
      </form>
    </div>
  );
};

export default SimpleChat;

const styles: Record<string, React.CSSProperties> = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    width: '100%',
    height: '100%',
    border: '1px solid #ccc',
    borderRadius: 8,
    padding: 10,
    fontFamily: 'sans-serif',
  },
  chatBox: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    gap: 5,
    overflowY: 'auto',
    marginBottom: 10,
  },
  message: {
    padding: 10,
    borderRadius: 12,
    maxWidth: '80%',
  },
  inputForm: {
    display: 'flex',
    gap: 5,
  },
  input: {
    flex: 1,
    padding: 8,
    borderRadius: 5,
    border: '1px solid #ccc',
  },
};
