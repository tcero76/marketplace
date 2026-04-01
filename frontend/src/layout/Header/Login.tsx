'use client'

import { Button } from '@/components/ui/button';
import { v4 as uuidv4 } from 'uuid';
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  BadgeCheckIcon,
  BellIcon,
  CreditCardIcon,
  LogOutIcon,
} from "lucide-react"
import { useGetAuthenticatedQuery, useLogoutMutation } from '@/http/api';

const Login = () => {
    const { data } = useGetAuthenticatedQuery()
    const [ logout ] = useLogoutMutation()
    const onClickLogin = () => {
        const state = uuidv4();
        sessionStorage.setItem('state', state);
        const params = new URLSearchParams({
        client_id: process.env.NEXT_PUBLIC_CLIENT_ID || '657d...',
        response_type: 'code',
        scope: 'openid offline mediamtx:stream',
        state,
        redirect_uri: `${process.env.NEXT_PUBLIC_HOST}/bff/callback`,
        });
        window.location.href = `${process.env.NEXT_PUBLIC_HOST}/hydra/oauth2/auth?${params.toString()}`;
    }
    const onClickLogout = async ( e: React.MouseEvent<HTMLElement>) => {
        e.preventDefault()
        try {
            await logout().unwrap()
            window.location.href = "/home"
        } catch (err) {
            console.error("Error en logout", err)
        }
    }
    return (
        <>{ data?.sub ? 
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="rounded-full">
                <Avatar>
                    <AvatarImage src={data.ext.picture} alt="shadcn" />
                    <AvatarFallback>LR</AvatarFallback>
                </Avatar>
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
                <DropdownMenuGroup>
                <DropdownMenuItem>
                    <BadgeCheckIcon />
                    Account
                </DropdownMenuItem>
                <DropdownMenuItem>
                    <CreditCardIcon />
                    Billing
                </DropdownMenuItem>
                <DropdownMenuItem>
                    <BellIcon />
                    Notifications
                </DropdownMenuItem>
                </DropdownMenuGroup>
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={onClickLogout}>
                    <LogOutIcon />
                    Sign Out
                </DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>
      : <Button onClick={onClickLogin}>login</Button>}
      </>
    )
}

export default Login;