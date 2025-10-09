import {} from 'react'
import { type MessagesProps } from '../../../types'
const Messages = ({messages}:MessagesProps) => {
    const style = { 
        overflowY: 'auto',
        width: '30em',
        height: '25em'
    }
    return (<div className="card" style={style}>
                {messages.map(msg => <div>{msg.user}: {msg.message}</div>)}
            </div>
    )
}

export default Messages;