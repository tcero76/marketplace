'use client'

import { FC, useEffect } from 'react'
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import Link from 'next/dist/client/link';
import { useQueries } from '@tanstack/react-query';
import { useGetTsQuery } from '@/http/api';
import { ItemProps } from '@/types';

const Item:FC<ItemProps> = ({item, idx}:ItemProps) => {
const id = item?.idItem;

const { data } = useGetTsQuery(
   item?.idItem,
  { skip: ! item?.idItem });
  useEffect(() => {
    console.log("🚀 ~ Item ~ item:", item)
  },[item])
  // const results = useQueries({
  //   queries: [{
  //     queryKey: ['ts', data],
  //     queryFn: async () => {},
  //     staleTime: 1000 * 60 * 10,
  //     cacheTime: 1000 * 60 * 60,
  //   }]})
  return (
<Card className="w-full h-full flex flex-col">
  <div className="flex flex-col h-full space-y-4 p-4">
    
    {/* HEADER */}
    <div className="space-y-1">
      <CardTitle className="text-base font-semibold leading-tight">
        {data?.nombre}
      </CardTitle>
      <CardDescription className="text-sm text-muted-foreground">
        {data?.ciudad}
      </CardDescription>
    </div>

    {/* CONTENT */}
    <div className="flex-1">
      <p className="text-sm text-muted-foreground line-clamp-3">
        {data?.descripcion}
      </p>
    </div>

    {/* FOOTER */}
    <div className="pt-2">
      <Button asChild variant="outline" size="sm" className="w-full">
        <Link href={`/modelos/${data?.id}`}>
          {data?.portal}
        </Link>
      </Button>
    </div>

  </div>
</Card>
  )
}

export default Item