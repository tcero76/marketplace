'use client'

import { } from 'react';
import Search from './Search'
import { useAuthDispatch } from '../../store/hooks';
import getUserApi  from '../../http/HttpFactory';
import name from '@/app/assets/name.svg';
import Icon from '../../components/icons/Icon';
import Link from "next/link"
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "@/components/ui/navigation-menu"
import { Item, ItemContent, ItemDescription, ItemTitle } from "@/components/ui/item"
import Login from './Login';
const Header = () => {
    return(
    <header>
        <div className="container flex h-14 sm:h-16 items-center px-4 md:px-6">
            <div className="flex items-center gap-3 md:gap-4 shrink-0">
                <Icon/>
                <img src={name.src} alt="Logo" width="140" height="48"/>
            </div>
            <div className="flex-1 flex justify-center">
                <NavigationMenu>
                    <NavigationMenuList>
                        <NavigationMenuItem>
                        <NavigationMenuTrigger>Getting started</NavigationMenuTrigger>
                        <NavigationMenuContent>
                            <ul className="w-96 bg-white">
                                <Item>
                                    <Link href="/home">
                                        <ItemContent>
                                        <ItemTitle>Home</ItemTitle>
                                            <ItemDescription>
                                                Catálogo de productos, ofertas y novedades.
                                            </ItemDescription>
                                        </ItemContent>
                                    </Link>
                                </Item>
                            </ul>
                        </NavigationMenuContent>
                        </NavigationMenuItem>
                    </NavigationMenuList>
                </NavigationMenu>
            </div>
            <div/>
            <div className="flex items-center gap-2 md:gap-4 shrink-0">
                <Search/>
                <Login/>
            </div>
        </div>
    </header>
  )    // return (
    //         <nav className="navbar navbar-expand-lg bg-body-tertiary">
    //             <div className="container-fluid">
    //             <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
    //                 <span className="navbar-toggler-icon"></span>
    //             </button>
    //             <div className="collapse navbar-collapse" id="navbarTogglerDemo01">
    //                 <ul className="navbar-nav me-auto mb-2 mb-lg-0">
    //                     <li className="nav-item">
    //                         <a className="nav-link enabled" aria-current="page" href="/home">Home</a>
    //                     </li>
    //                 </ul>
    //                 <ul className="navbar-nav me-2">
    //                     <li className="nav-item dropdown me-2" ref={dropdownRef}>
    //                         <div className="position-relative" style={{ width: '50px', height: '50px' }}>
    //                             { state.isAuthenticated &&
    //                                 <button className="btn dropdown-toggle rounded-circle" data-bs-toggle="dropdown"
    //                                     style={{backgroundImage: `url("${state.avatar}")`, backgroundSize: 'cover', backgroundPosition: 'center'}}
    //                                     aria-expanded="false" onClick={onClickDropdown}>
    //                                 </button>
    //                             }
    //                         </div>
    //                         <ul className="dropdown-menu me-2" style={{ transform: 'translate(-130px, 0)'}}>
    //                             <li><a className="dropdown-item" href="#">Another action</a></li>
    //                             <li><a className="dropdown-item" href="#">Something else here</a></li>
    //                         </ul>
    //                     </li>
    //                 </ul>
    //             </div>
    //             </div>
    //         </nav>
    // )
}
export default Header;