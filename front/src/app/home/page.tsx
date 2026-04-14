'use client'

import { useEffect, useMemo, useRef, useState } from 'react';
import { useAuthDispatch } from '@/store/hooks';
import { Virtuoso } from 'react-virtuoso';
import {
  useGetAuthenticatedQuery,
  useGetTsesIdxQuery,
 } from '@/http/api';
import { useSearchParams } from 'next/navigation';
import { setToken } from '@/store/AuthSlice';
import { skipToken } from '@reduxjs/toolkit/query';
import Row from './search/Row';

export default function Home() {
  const dispatch = useAuthDispatch()
  const { data:user } = useGetAuthenticatedQuery()
  const { data, isLoading:isLoadingRecomendations } = useGetTsesIdxQuery(user?.sub ? undefined : skipToken);
  const searchParams = useSearchParams();
  useEffect(() => {
    const at = searchParams.get('accessToken');
    if (at) {
      dispatch(setToken(at))
      const url = new URL(window.location.href)
      url.searchParams.delete('accessToken')
      window.history.replaceState({}, '', url.toString())
    }
  }, [searchParams]);
  const rows = useMemo(() => {
  if (!data?.length) return [];
  return Array.from(
    { length: Math.ceil(data.length / 3) },
    (_, index) => {
      const start = index * 3;
      return {
        row: data.slice(start, start + 3),
        key: start,
      };
    }
  );
}, [data]);
  if (!user) return <div>No estás logeado</div>;
  if (isLoadingRecomendations) return <div>Cargando recomendaciones...</div>;
  return (
    <div className="h-full w-full">
        <Virtuoso
          data={rows}
          itemContent={(index, item) => <Row key={item.key} row={item.row}/>}
          computeItemKey={(index) => index}
        >
        </Virtuoso>
    </div>
  );
}
