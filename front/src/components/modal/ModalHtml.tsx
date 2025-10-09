import { ForwardedRef, forwardRef, useImperativeHandle, useRef } from 'react'
import Button from '../buttons/Button'
import { Modal } from 'bootstrap'

export type ModalHtmlProps = {
    onClickModal: () => void
    children: React.ReactNode
    isHeader?: boolean
    textHeader?: string
    textBtnAccept?: string
}

export type ModalHtmlHandle = {
  open: () => void;
  close: () => void;
};
const ModalHtml= forwardRef<ModalHtmlHandle, ModalHtmlProps>((
  {isHeader=false,textHeader,textBtnAccept = "Guardar",onClickModal, children},
    ref:ForwardedRef<ModalHtmlHandle>) => {
    const refModal = useRef<HTMLDivElement>(null);
    useImperativeHandle(ref, () => ({
      open: () => {
        const modalElement = refModal.current!
        const modal = Modal.getOrCreateInstance(modalElement, { backdrop: 'static' })
        modal.show();
      },
      close: () => {
        const modalElement = refModal.current!;
        const modal = Modal.getInstance(modalElement);
        if (modal) {
          modal.hide();
        }
      },
    }), []);
    return (
        <div className="modal fade" tabIndex={-1} ref={refModal}>
            <div className="modal-dialog">
                <div className="modal-content rounded">
                {isHeader && <div className="modal-header">
                    <h5 className="modal-title">{textHeader}</h5>
                    <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>}
                <div className="modal-body">
                    {children}
                </div>
                <div className="modal-footer">
                    <Button btnType="secondary" label="Close"
                        data-bs-dismiss="modal"/>
                    <Button btnType="primary" label={textBtnAccept}
                    onClick={onClickModal}/>
                </div>
                </div>
            </div>
        </div>
    )
})

export default ModalHtml