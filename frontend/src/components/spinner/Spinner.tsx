import { useImperativeHandle, useRef, forwardRef, ForwardedRef, useState } from 'react'
import { SpinnerRef } from '../../types';
import { LoaderIcon } from 'lucide-react';

type SpinnerProps = {}  

const Spinner = forwardRef<SpinnerRef,SpinnerProps>((_props, ref:ForwardedRef<SpinnerRef>) => {
  const [visible, setVisible] = useState<boolean>(false);
  const spinnerRef = useRef<HTMLDivElement>(null);
  useImperativeHandle(ref, () => ({
      show: () => setVisible(true),
      hide: () => setVisible(false)
    }))
  return (
    <>
      {visible &&
        <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/60 backdrop-blur-sm">
            <div className="flex flex-col items-center gap-3">
                <LoaderIcon className="size-12 animate-spin text-white" />
                <p className="text-white text-sm font-medium">Cargando...</p>
            </div>
        </div>}
    </>
  )
})

export default Spinner