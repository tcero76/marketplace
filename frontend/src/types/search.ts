export type SearchType = {
    mention: string;
    text: string[];
}

export type SearchProps = {
    onSearch: (search:SearchType) => void;
}

export type SearchPosts = {
    idItem: string
    score: number
  }