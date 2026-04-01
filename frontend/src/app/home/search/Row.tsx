'use client'

import { FC  } from 'react'
import { RowProps } from '@/types';
import Item from '../Item';

const Row:FC<RowProps> = ({ row }:RowProps) => {
    if(!row) return
    return (
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 md:gap-6 mb-6 text-center">
        {row.map((item, idx) => {
          return (
            <Item key={idx} item={item} idx={idx}/>
          )
        })}
      </div>)
}

export default Row;