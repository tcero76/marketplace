import { useEffect } from 'react'
import getUserApi from '../../http/HttpFactory'
import { useAuthDispatch } from '../../store/hooks'
import SimpleChat from './chat/SimpleChat'
import Pago from './Pago'
import { VideoPlayer } from './VideoPlayer'
import CreatePost from './CreatePost'

const Detalle = () => {
    const dispatch = useAuthDispatch()
  useEffect(() => {
    dispatch(getUserApi().getAuthenticated())
  },[])
    return (
    <div className="py-4">
    <div className="row mb-3">
      <div className="col bg-primary text-white p-3 rounded">
        <VideoPlayer/>
      </div>
      <div className="col bg-success text-white p-3 rounded">
        <SimpleChat/>
      </div>
    </div>
    <div className="row">
      <div className="col bg-warning p-3 rounded">
        <Pago/>
      </div>
    </div>
    <div className="row">
      <div className="col bg-danger p-3 rounded">
        <CreatePost/>
      </div>
    </div>
  </div>
      )
}
export default Detalle