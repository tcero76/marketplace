import { useEffect, useState } from 'react'
import { Outlet } from 'react-router';
import Header from './Header/Header';
import Footer from './Footer';
import getUserApi  from "../http/HttpFactory"
import { useAuthDispatch } from '../store/hooks';
import LoginModal from './LoginModal.tsx';
import { SearchType } from '../types/index.ts';
import 'bootstrap-icons/font/bootstrap-icons.css';

const Layout = () => {
  const dispatch = useAuthDispatch()
  const [search, setSearch] = useState<SearchType>({text:[], mention:""});
  useEffect(() => {
    const url = new URL(window.location.href);
    const accessToken = url.searchParams.get("accessToken");
    if (accessToken) {
      sessionStorage.setItem("Access_Token", accessToken);
      url.searchParams.delete("accessToken");
      window.history.replaceState({}, document.title, url.toString());
    }
    dispatch(getUserApi().getAuthenticated())
  }, [])
  return (<div className="d-flex flex-column vh-100">
              <Header onSearch={setSearch} />
              <LoginModal/>
              <div className="flex-grow-1 overflow-hidden">
                  <Outlet context={search}/>
              </div>
              <Footer/>
          </div>)
}

export default Layout