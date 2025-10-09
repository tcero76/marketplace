import { useEffect, useState } from 'react';
import { Recomendations } from '../../types';
import getUserApi  from "../../http/HttpFactory"
import { AxiosResponse } from 'axios';
import { useAuthSelector } from '../../store/hooks';
import Item from './Item';
import { Virtuoso } from 'react-virtuoso';
import { useLocation } from 'react-router';

export default function App() {
  const location = useLocation();
  const search = location.state as { mention: string; text: string } | null;
  const state = useAuthSelector((state) => state.auth);
  const [recomendations, setRecomendations] = useState<Recomendations[][]>([]);
  useEffect(() => {
    if(state.isAuthenticated) {
      getUserApi().getRecomendations(state.userId)
      .then((response:AxiosResponse<Recomendations[]>) => {
        const chunk = 3
        const result = [];
        for (let i = 0; i < response.data.length; i += chunk) {
          result.push(response.data.slice(i, i + chunk));
        }
        setRecomendations(result);
      }).catch((error) => {
        console.error("Error fetching recommendations:", error);
      });
    }
  }, [state.isAuthenticated])
  useEffect(() => {
    console.log("🚀 ~ App ~ search:", search)
    getUserApi().searchPosts(search)
    .then((res) => {
      const recomendationsSearch = res.data.map(s => ({
        user_id:s.id.toString(),
        modelo:s.modelo,
        score: s.rank
      }))
      const chunk = 3
      const result = [];
      for (let i = 0; i < recomendationsSearch.length; i += chunk) {
        result.push(recomendationsSearch.slice(i, i + chunk));
      }
      setRecomendations(result)
    }
    ).catch((error) => {
        console.error("Error searching posts:", error);
      }
    );
  },[search])
  if(recomendations.length===0) return
  return (
    <Virtuoso
      style={{ overflowX: 'hidden' }}
      data={recomendations}
      itemContent={(index, item) => {
        return <Item key={index} item={item}/>
      }}
    >
    </Virtuoso>
  );
};