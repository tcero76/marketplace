import { createContext, useContext, useRef } from "react";
import ToastHtml from "../components/toast/ToastHtml";
import { ToastContextType, ToastHtmlRef, type ToastState } from "../types";

const ToastContext = createContext<ToastContextType | null>(null);

export const useToast = () => {
  const ctx = useContext(ToastContext);
  if (!ctx) {
    throw new Error("useToast must be used within ToastProvider");
  }
  return ctx;
};

export const ToastProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const toastRef = useRef<ToastHtmlRef>(null);
  const showToast = (toastState:ToastState) => {
    toastRef.current?.show(toastState);
  };

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
        <ToastHtml ref={toastRef} />
    </ToastContext.Provider>
  );
};
