
export type ModalHtmlProps = {
    onClickModal: () => void
    children: React.ReactNode
    isHeader?: boolean
    textHeader?: string
    textBtnAccept?: string
    iconBtnAccept?: string
}

export type ModalHtmlHandle = {
  open: () => void;
  close: () => void;
};