export type SearchType = {
    mention: string;
    text: string[];
}

export type SearchProps = {
    onSearch: (search:SearchType) => void;
}

export type SearchPosts = {
    id: number
    descripcion:string
    descripcionTSV:string
    modelo:string
    rank:number
  }

  export type HeaderProps = {
    onSearch: (search: SearchType) => void;
  };