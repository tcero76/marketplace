import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import {  RouterProvider } from 'react-router';
import { Provider } from 'react-redux';
import { store } from './store/store.tsx'
import './assets/_variables.scss'
import router from './router/Router.tsx';
import { ToastProvider } from './context/UIContext.tsx';

createRoot(document.getElementById('root')!).render(
    <StrictMode>
        <Provider store={store}>
          <ToastProvider>
            <RouterProvider router={router}/>
          </ToastProvider>
        </Provider>
    </StrictMode>
)
