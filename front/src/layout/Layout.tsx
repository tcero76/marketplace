import { useEffect } from 'react'
import { Outlet } from 'react-router';
import Header from './Header/Header';
import Footer from './Footer';
import { useAuthDispatch } from '../store/hooks';
import LoginModal from './LoginModal.tsx';
import 'bootstrap-icons/font/bootstrap-icons.css';
import getUserApi from '../http/HttpFactory.ts';

const Layout = () => {
  const dispatch = useAuthDispatch()
  useEffect(() => {
    const url = new URL(window.location.href);
    const accessToken = url.searchParams.get("accessToken");
    if (accessToken) {
      sessionStorage.setItem("Access_Token", accessToken);
      url.searchParams.delete("accessToken");
      window.history.replaceState({}, document.title, url.toString());
    }
    dispatch(getUserApi().getAuthenticated());
  }, [])
  return (<div className="d-flex flex-column vh-100">
              <Header/>
              <LoginModal/>
              <div className="flex-grow-1 overflow-hidden">
                  <Outlet/>
              </div>
              <Footer/>
          </div>)
}

export default Layout