export type ToastHtmlProps = {
    isHeader?: boolean
}

export const TOAST_TYPES = {
    PRIMARY: "primary",
    SECONDARY: "secondary",
    SUCCESS: "success",
    DANGER: "danger",
    WARNING: "warning",
    INFO: "info",
    LIGHT: "light",
    DARK: "dark",
  } as const;
  
export type ToastType = (typeof TOAST_TYPES)[keyof typeof TOAST_TYPES];

export type ToastState = {
    msg: string
    type?: ToastType
}

export type ToastHtmlRef = {
    show: (toastState:ToastState) => void
}

export type SpinnerRef = {
  show: () => void;
  hide: () => void;   
} 

export type UIContextType = {
  showToast: (toastState: ToastState) => void;
  showSpinner: () => void;
  hideSpinner: () => void;
};