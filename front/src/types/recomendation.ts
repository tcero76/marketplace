

export type Recomendations = {
    user_id:string
    modelo:string
    score:number
  }

export type RowProps = {
  key: number
  row: IdxProps[]
}

export type IdxProps = {
  idItem:string
}

export type ItemProps = {
  item:IdxProps
  idx: number
}

export type Ts = {
    id:string
    id_job:number
    portal:string
    idpagina:string
    nombre:string
    edad:number
    ciudad:string
    servicios:string[]
    servicios_adicionales: string[]
    scraped: string,
    descripcion:string
    deleted_at: string
    created: string
    updated: string
}