import { useRef } from 'react';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import Search from './Search.tsx'
import { useLocation } from "react-router-dom";
import { useAuthSelector, useAuthDispatch } from '../../store/hooks.tsx';
import getUserApi  from '../../http/HttpFactory.ts';
import name from '../../assets/name.svg';
import Icon from '../../components/icons/Icon.tsx';
import { Dropdown } from 'bootstrap';
import { type HeaderProps } from '../../types/index.ts';

const Header = ({onSearch}:HeaderProps) => {
    const location = useLocation();
    const dispatch = useAuthDispatch()
    const dropdownRef = useRef<HTMLLIElement>(null);
    const state = useAuthSelector((state) => state.auth);
    const onClickLogout = (e:React.MouseEvent<HTMLAnchorElement, MouseEvent>) => {
        e.preventDefault();
        dispatch(getUserApi().logout());
    }
    const onClickDropdown = (e:React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        e.preventDefault();
        const dropdown = Dropdown.getOrCreateInstance(dropdownRef.current!)
        dropdown.toggle();
    }
    return (
            <nav className="navbar navbar-expand-lg bg-body-tertiary">
                <div className="container-fluid">
                    <Icon/>
                <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>
                <div className="collapse navbar-collapse" id="navbarTogglerDemo01">
                    <img src={name} alt="Logo" width="140" height="48"/>
                    <ul className="navbar-nav me-auto mb-2 mb-lg-0">
                        <li className="nav-item">
                            <a className={"nav-link" +(location.pathname==="/home"?" disabled":" enabled")} aria-current="page" href="/home">Home</a>
                        </li>
                    </ul>
                    <Search/>
                    <ul className="navbar-nav me-2">
                        <li className="nav-item dropdown me-2" ref={dropdownRef}>
                            <div className="position-relative" style={{ width: '50px', height: '50px' }}>
                                { state.isAuthenticated &&
                                    <button className="btn dropdown-toggle rounded-circle" data-bs-toggle="dropdown"
                                    style={{backgroundImage: `url("${state.avatar}")`, backgroundSize: 'cover', backgroundPosition: 'center'}}
                                    aria-expanded="false" onClick={onClickDropdown}>
                                    </button>
                                }
                            </div>
                            <ul className="dropdown-menu me-2" style={{ transform: 'translate(-130px, 0)'}}>
                                <li><a className="dropdown-item" href="#" onClick={onClickLogout}>Logout</a></li>
                                <li><a className="dropdown-item" href="#">Another action</a></li>
                                <li><a className="dropdown-item" href="#">Something else here</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                </div>
            </nav>
    )
}
export default Header;