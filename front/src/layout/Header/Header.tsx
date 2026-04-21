'use client'

import { } from 'react';
import Search from './Search'
import name from '@/app/assets/name.svg';
import Icon from '../../components/icons/Icon';
import Link from "next/link"
import { useMediaQuery } from "@/hooks/use-media-query.ts"
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "@/components/ui/navigation-menu"
import { Item, ItemContent, ItemDescription, ItemTitle } from "@/components/ui/item"
import Login from './Login';
import { Sheet, SheetClose, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet';
import { Label } from '@/components/ui/label';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
const Header = () => {
    const isDesktop = useMediaQuery("(min-width: 768px)")
    if (isDesktop) {
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
} else {
    return (<Sheet>
                <SheetTrigger>☰</SheetTrigger>
                <SheetContent side="left" className="bg-white">
                <SheetHeader>
                    <SheetTitle>Edit profile</SheetTitle>
                </SheetHeader>
                <Search className="mt-7"/>
                <nav className="mt-6 flex flex-col gap-4">
                    <a href="/home">Inicio</a>
                </nav>
                </SheetContent>
            </Sheet>)
}
}
export default Header

