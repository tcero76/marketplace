import { ForwardedRef, forwardRef, useImperativeHandle, useRef, useState } from 'react'
import { Toast } from 'bootstrap'
import {
    TOAST_TYPES,
    type ToastHtmlProps,
    type ToastHtmlRef,
    type ToastState } from '../../types'

const ToastHtml = forwardRef<ToastHtmlRef,ToastHtmlProps>(({isHeader=false}:ToastHtmlProps,ref:ForwardedRef<ToastHtmlRef>) => {
    const refToast = useRef<HTMLDivElement>(null)
    const [toastState, setToastState] = useState<ToastState>({msg:'', type:'primary'})
    useImperativeHandle(ref, () => ({
        show: (s:ToastState) => {
            setToastState(s)
            Object.values(TOAST_TYPES).forEach(t => {
                if(refToast.current?.classList.contains(`bg-${t}`)) {
                    refToast.current?.classList.remove(`bg-${t}`)
                }
            })
            if(s.type && refToast.current) {
                refToast.current.classList.add(`bg-${s.type}`)
            }
            const toastElement = refToast.current!
            const toast = Toast.getOrCreateInstance(toastElement)
            toast?.show()
        }
    }), [])
  return (
    <div className="toast-container top-0 start-50 translate-middle-x">
        <div className={`toast mt-5`} role="alert" aria-live="assertive"
            ref={refToast} aria-atomic="true">
            {isHeader &&<div className="toast-header">
                <img src="..." className="rounded me-2" alt="..."/>
                <strong className="me-auto">Bootstrap</strong>
                <small>11 mins ago</small>
                <button type="button" className="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>}
            <div className="toast-body">
                {toastState.msg}
            </div>
        </div>
    </div>)
})
export default ToastHtml