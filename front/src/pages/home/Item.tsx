import { FC, useEffect, useState } from 'react'
import { Modelo, Recomendations } from '../../types';
import getUserApi  from "../../http/HttpFactory"

type ItemProps = {
    item: Recomendations[]
}

const Item:FC<ItemProps> = ({item}:ItemProps) => {
    const [modelos, setModelos] = useState<(Modelo | null)[]>([null, null, null]);
    useEffect(() => {
        const fetchModelos = async () => {
            try {
              const results = await Promise.all(
                item.map((i) =>
                  getUserApi()
                    .getModelo(i.modelo)
                    .then((res) => res.data)
                    .catch((err) => {
                      console.error("Error fetching modelo:", err);
                      return null;
                    })
                )
              );
              setModelos(results);
            } catch (error) {
              console.error("Unexpected error fetching modelos:", error);
            }
          };
          fetchModelos();
    }, [item]);
    return (
        <div className="row mb-3 text-center">
            {modelos.map((modelo) => (
                <div className="col-sm-4 themed-grid-col">
                        <div className="card" style={{width: '18rem'}}>
                            <div className="card-body">
                                <h5 className="card-title">{modelo?.modelo}</h5>
                                <h6 className="card-subtitle mb-2 text-body-secondary">Card subtitle</h6>
                                <p className="card-text text-truncate">{modelo?.descripcion}</p>
                                <a href={`https://arsmate.com/${modelo?.modelo}`} className="card-link">Card link</a>
                                <a href={`/detalle/${modelo?.modelo}`} className="card-link">Another link</a>
                            </div>
                        </div>
                    </div>
            ))}
        </div>
    )
}

export default Item;