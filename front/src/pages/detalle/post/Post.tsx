import { } from 'react'
import { PostProps } from '../../../types';
import Button from '../../../components/buttons/Button';
import { useAuthSelector } from '../../../store/hooks';

const btnIconOnly = {
    padding: '8px', 
    width: '40px',
    height: '40px',
    position: "absolute",
    top: "0.5rem",
    right: "0.5rem",
    zIndex: "1",
  }

const Post = ({index, editar}:PostProps) => {
    const state = useAuthSelector((state => state.auth))
    const onClickEdit = () => {
        editar(index)
    }
    return (
        <div className="card" style={{width: "18rem;", border:  'none'}}>
            {state.userId == index.userId && <Button icon="pen" btnType="primary"
                onClick={onClickEdit}
                style={btnIconOnly}/>}
            <div className="card-body">
                <p className="pe-4 ps-2">{index.texto}</p>
            </div>
        </div> 
    )
}

export default Post