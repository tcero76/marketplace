import { FC, useState, FormEvent, useEffect, useRef } from 'react';
import { Socket, Channel } from 'phoenix';
import { type Message } from '../../../types/index.ts'
import { useAuthSelector } from '../../../store/hooks.tsx';
import Button from '../../../components/buttons/Button.tsx';

const SimpleChat: FC = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState<string>('');
  const [socket, setSocket ] = useState<Socket>();
  const [channel, setChannel] = useState<Channel>();
  const containerRef = useRef<HTMLDivElement>(document.createElement('div'))
  const { userId } = useAuthSelector((state) => state.auth)
  useEffect(() => {
    const el = containerRef.current;
    if (el) {
      el.scrollTop = el.scrollHeight;
    }
  },[messages])
  useEffect(() => {
    channel?.join()
      .receive("ok", () => {
        console.log("Conectado al canal room:lobby");
        setChannel(channel);
      })
      .receive("error", (resp) => {
        console.log("Error al conectar", resp);
      });
      channel?.on("message:new", (payload) => {
        setMessages((prev) => [...prev, { 
          userId:payload.userId,
          message:payload.body
        }]);
      });
      return () => {
        channel?.leave();
      }
  },[channel])
  useEffect(() => {
    socket?.connect()
    setChannel(socket?.channel("room:lobby", {}));
    return () => {
      console.log("Cerrando WebSocket...");
      socket?.disconnect();
    }
  },[socket])
  useEffect(() => {
    setSocket(new Socket(`${import.meta.env.VITE_WS}/api/socket`, { params: { token: sessionStorage.getItem("Access_Token") }}));
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
  return (
    <div style={styles.container}>
      <div
      ref={containerRef}
      style={styles.chatBox}
      >
        {messages.map((msg,idx) => (
          <div
            key={idx}
            style={{
              ...styles.message,
              alignSelf: msg.userId === userId ? 'flex-end' : 'flex-start',
              backgroundColor: msg.userId === userId ? '#DCF8C6' : '#EEE',
            }}
          >
            {msg.message}
          </div>
        ))}
      </div>
      <form onSubmit={handleSubmit} style={styles.inputForm}>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Escribe un mensaje..."
          style={styles.input}
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
    maxWidth: 400,
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
    maxHeight: 300,
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
