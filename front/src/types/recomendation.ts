

export type Recomendations = {
    user_id:string
    modelo:string
    score:number
  }

export type ItemProps = {
  key: number,
  item: Recomendations[]
}