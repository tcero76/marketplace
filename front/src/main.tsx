import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import {  RouterProvider } from 'react-router';
import { Provider } from 'react-redux';
import { store } from './store/store.tsx'
import './assets/_variables.scss'
import router from './router/Router.tsx';
import { UIProvider } from './context/UIContext.tsx';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

createRoot(document.getElementById('root')!).render(
    <StrictMode>
        <Provider store={store}>
          <UIProvider>
            <QueryClientProvider client={queryClient}>
              <RouterProvider router={router}/>
              {import.meta.env.VITE_PROFILE == 'dev' && <ReactQueryDevtools initialIsOpen={false} />}
            </QueryClientProvider>
          </UIProvider>
        </Provider>
    </StrictMode>
)
