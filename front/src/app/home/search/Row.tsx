'use client'

import { FC  } from 'react'
import { RowProps } from '@/types';
import Item from '../Item';

const Row:FC<RowProps> = ({ row }:RowProps) => {
    if(!row) return
    return (
      <div className="sm:px-6 lg:px-0 lg:mx-auto lg:max-w-5xl grid grid-cols-1 sm:grid-cols-3 gap-4 md:gap-4 text-center py-3">
        {row.map((item, idx) => {
          return (
            <Item key={idx} item={item} idx={idx}/>
          )
        })}
      </div>)
}

export default Row;