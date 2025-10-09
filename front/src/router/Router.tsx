
import {} from 'react';
import { createBrowserRouter } from 'react-router';
import Layout from '../layout/Layout.tsx';
import Detalle from '../pages/detalle/Detalle.tsx';
import Login from '../pages/Login.tsx';
import App from '../pages/home/App.tsx';

const router = createBrowserRouter([
  {
      path: "/",
      element: <Layout/>,
      children: [{
            path: "home",
            Component: App,
        },{
          path: "login",
          Component: Login,
          },
        {
          path: "detalle/:modelo",
          Component: Detalle,
        }]
  }
]);

export default router