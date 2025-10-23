import { useEffect, useRef, useState } from 'react';
import { Recomendations } from '../../types';
import getUserApi  from "../../http/HttpFactory"
import { AxiosResponse } from 'axios';
import { useAuthSelector } from '../../store/hooks';
import Item from './Item';
import { Virtuoso, VirtuosoHandle } from 'react-virtuoso';
import { useLocation } from 'react-router';
import { useUIContext } from '../../context/UIContext';

export default function App() {
  const container = useRef<VirtuosoHandle>(null);
  const location = useLocation();
  const search = location.state as { mention: string; text: string } | null;
  const state = useAuthSelector((state) => state.auth);
  const [recomendations, setRecomendations] = useState<Recomendations[][]>([]);
  const uiContext = useUIContext()
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
    uiContext.showSpinner()
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
      uiContext.hideSpinner()
    }
    ).catch((error) => {
        console.error("Error searching posts:", error);
        uiContext.hideSpinner()
      }
    );
  },[search])
  if(recomendations.length===0) return
  return (
    <Virtuoso ref={container}
      style={{ overflowX: 'hidden' }}
      data={recomendations}
      itemContent={(index, item) => <Item key={index} item={item}/>}
      computeItemKey={(index) => index}
    >
    </Virtuoso>
  );
};