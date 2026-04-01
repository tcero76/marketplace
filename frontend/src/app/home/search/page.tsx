'use client';

import { useUIContext } from '@/context/UIContext';
import { useSearchParams } from 'next/navigation';
import {  useEffect, useMemo } from 'react';
import { Virtuoso } from 'react-virtuoso';
import { useSearchTsQuery } from '@/http/api';
import Row from './Row';

export default function Page() {
  const searchParams = useSearchParams();
  const uiContext = useUIContext()
  const mention = searchParams.get("mention") ?? "";
  const text = searchParams.get("text") ?? "";
  const { data , isLoading } = useSearchTsQuery({ mention, text:[text]}, 
    { skip: !text && !mention });
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
  useEffect(() => {
    if (isLoading) {
        uiContext.showSpinner();
    } else {
        uiContext.hideSpinner();
    }
    return () => {
        uiContext.hideSpinner();
    };
  }, [isLoading, uiContext]);
  return (
    <div className="h-full w-full">
        <Virtuoso
          style={{height: '100%',overflowX: 'hidden' }}
          data={rows}
          itemContent={(index, item) => <Row key={item.key} row={item.row}/>}
          computeItemKey={(index) => index}
        >
        </Virtuoso>
    </div>
    )
}