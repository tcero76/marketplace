
export type MessagesProps = {
    messages:Message[]
}

export type Message = {
    userId:string
    message:string
    extName:string
  }

export type SimpleChatProps = {
  roomName?: string;
}