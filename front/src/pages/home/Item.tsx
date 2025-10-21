import { FC  } from 'react'
import { useQueries } from '@tanstack/react-query'
import { ItemProps } from '../../types';
import getUserApi  from "../../http/HttpFactory"


const Item:FC<ItemProps> = ({key, item}:ItemProps) => {
  const results = useQueries({
    queries: item.map(i => ({
      queryKey: ['modelo', i.modelo], // clave única por modelo
      queryFn: async () => {
        const res = await getUserApi().getModelo(i.modelo)
        return res.data
      },
      staleTime: 1000 * 60 * 10, // 10 minutos "frescos"
      cacheTime: 1000 * 60 * 60, // 1 hora en caché
    })),
  })
    return (
        <div key={key} className="row mb-3 text-center">
      {results.map((result, idx) => {
        if (result.isLoading) return <p key={idx}>Cargando...</p>
        if (result.error) return <p key={idx}>Error</p>

        const modelo = result.data
        return (
          <div key={idx} className="col-sm-4 themed-grid-col">
            <div className="card" style={{ width: '18rem' }}>
              <div className="card-body">
                <h5 className="card-title">{modelo?.modelo}</h5>
                <h6 className="card-subtitle mb-2 text-body-secondary">Card subtitle</h6>
                <p className="card-text text-truncate">{modelo?.descripcion}</p>
                <a href={`https://arsmate.com/${modelo?.modelo}`} className="card-link">Card link</a>
                <a href={`/detalle/${modelo?.modelo}`} className="card-link">Another link</a>
              </div>
            </div>
          </div>
        )
      })}
        </div>
    )
}

export default Item;