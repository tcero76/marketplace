'use client'

import { } from 'react';
import Search from './Search'
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
    </header>)
}
export default Header;