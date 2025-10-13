import { useImperativeHandle, useRef, forwardRef, ForwardedRef } from 'react'
import { SpinnerRef } from '../../types';

type SpinnerProps = {}  

const Spinner = forwardRef<SpinnerRef,SpinnerProps>((props, ref:ForwardedRef<SpinnerRef>) => {
    const spinnerRef = useRef<HTMLDivElement>(null);
    useImperativeHandle(ref, () => ({
        show: () => {
          const spinner = spinnerRef.current;
          if (spinner) {
            spinner.classList.remove('visually-hidden');
          }
        },
        hide: () => {
            const spinner = spinnerRef.current;
          if (spinner) {
            spinner.classList.add('visually-hidden');
          }
        }
      }))
  return (
    <div id="spinner-overlay" className="position-fixed top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center"
    style={{ zIndex: 1050, display: 'none'}}>    
        <div className="spinner-border visually-hidden" style={{ width: '4rem', height: '4rem' }} role="status" ref={spinnerRef}>
            <span></span>
        </div>
    </div>
  )
})

export default Spinner