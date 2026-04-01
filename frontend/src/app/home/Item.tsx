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
            <div key={idx} className="w-full">
              <Card size="sm" className="mx-auto w-full max-w-sm">
                <CardHeader>
                  <CardTitle>{data?.nombre}</CardTitle>
                  <CardDescription>
                    {data?.ciudad}
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="line-clamp-3">
                    {data?.descripcion}
                  </p>
                </CardContent>
                <CardFooter>
                  <Button asChild variant="outline" size="sm" className="w-full">
                    <Link href={`/modelos/${data?.id}`}>
                      {data?.portal}
                    </Link>
                  </Button>
                </CardFooter>
              </Card>
            </div>
  )
}

export default Item