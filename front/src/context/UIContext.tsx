import { createContext, useContext, useRef } from "react";
import ToastHtml from "../components/toast/ToastHtml";
import {
  SpinnerRef,
  type UIContextType,
  type ToastHtmlRef,
  type ToastState } from "../types";
import Spinner from "../components/spinner/Spinner";

const UIContext = createContext<UIContextType | null>(null);

export const useUIContext = () => {
  const ctx = useContext(UIContext);
  if (!ctx) {
    throw new Error("useUIContext must be used within ToastProvider");
  }
  return ctx;
};

export const UIProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const toastRef = useRef<ToastHtmlRef>(null);
  const spinnerRef = useRef<SpinnerRef>(null);
  const showToast = (toastState:ToastState) => {
    toastRef.current?.show(toastState);
  };
  const showSpinner = () => {
    spinnerRef.current?.show();
  } 
  const hideSpinner = () => {
    spinnerRef.current?.hide();
  } 
  return (
    <UIContext.Provider value={{ showToast, showSpinner, hideSpinner }}>
      <Spinner ref={spinnerRef}/>
      {children}
        <ToastHtml ref={toastRef} />
    </UIContext.Provider>
  );
};
