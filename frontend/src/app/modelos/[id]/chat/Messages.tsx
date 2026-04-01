import {} from 'react'
import { type MessagesProps } from '../../../types'
const style = { 
    overflowY: 'auto',
    width: '30em',
    height: '25em'
}
const Messages = ({messages}:MessagesProps) => {
    return (<div className="card" {...style}>
                {messages.map(msg => <div>{msg.userId}: {msg.message}</div>)}
            </div>
    )
}

export default Messages;