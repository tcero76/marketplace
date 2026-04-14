export type SearchType = {
    mention: string;
    hashtag: string;
    text: string[];
}

export type SearchProps = {
    onSearch: (search:SearchType) => void;
}

export type SearchPosts = {
    idItem: string
    score: number
  }