'use client'

import { useEffect, type MouseEvent, useState, useRef } from 'react';
import { useAuthDispatch, useAuthSelector} from '../store/hooks';
import getUserApi from '../http/HttpFactory';
import { Input } from '@/components/ui/input';
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
} from "@/components/ui/field"
import { cn } from '@/lib/utils';
import { useLoginMutation } from '@/http/api';

type LoginModalProps = {
  challenge:string
} & React.ComponentProps<"div">

const LoginModal: React.FC<LoginModalProps> = ({
  challenge,
  className,
  ...props
}:LoginModalProps) => {
    const refToast = useRef<HTMLDivElement>(null);
    const dispatch = useAuthDispatch();
    const state = useAuthSelector((state) => state.auth);
    const [loginUrl, setLoginUrl] = useState<string>('')
    const [user, setUser ] = useState<string>("")
    const [ password, setPassword ] = useState<string>("")
    const [login, { isLoading, isError, error: mutationError }] = useLoginMutation()
  useEffect(() => {
    const url = new URL(window.location.href);
    const accessToken = url.searchParams.get("accessToken");
    if (accessToken) {
      sessionStorage.setItem("Access_Token", accessToken);
      url.searchParams.delete("accessToken");
      window.history.replaceState({}, document.title, url.toString());
    }
  }, [])
    useEffect(() => {
      setLoginUrl(`/bff/login?` +
          `login_challenge=${challenge}` +
          `&state=${sessionStorage.getItem("state")}` +
          `&idp=internal`)
        const toastElement = refToast.current!
        // const toast = Toast.getOrCreateInstance(toastElement, { autohide: false })
        // if(state.isAuthenticated === false && window.location.pathname !== '/login') {
        //     toast.show();
        //     dispatch(getUserApi().fetchLoginChallenge())
        // } else {
        //     toast.hide();
        // }
    },[challenge]);
    const onClickClose = () => {
        const toastElement = refToast.current!
        // const toast = Toast.getOrCreateInstance(toastElement, { autohide: false })
        // toast.hide();
    }
    const onClickAuth = (e:MouseEvent<HTMLAnchorElement, globalThis.MouseEvent>) => {
        e.preventDefault();
    }
    const onClickAuthGoogle = (e:MouseEvent<HTMLAnchorElement, globalThis.MouseEvent>) => {
        e.preventDefault();
        dispatch(getUserApi().loginGoogle());
    }
    const onClickSignUp = (e:MouseEvent<HTMLButtonElement, globalThis.MouseEvent>) => {
        e.preventDefault();
        dispatch(getUserApi().signUp({user, password}));
    }
    const onClickLogin = async () => {
      await login({ user, password }).unwrap()
    }
    return (
      <div className={cn("flex flex-col gap-6", className)} {...props}>
      <Card>
        <CardHeader>
          <CardTitle>Login to your account</CardTitle>
          <CardDescription>
            Enter your email below to login to your account
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form action={loginUrl} method="POST">
            <FieldGroup>
              <Field>
                <FieldLabel htmlFor="email">Email</FieldLabel>
                <Input
                  id="email"
                  type="text"
                  placeholder="user"
                  name="user"
                  value={user}
                  onChange={(ev) => setUser(ev.target.value)}
                  required
                />
              </Field>
              <Field>
                <div className="flex items-center">
                  <FieldLabel htmlFor="password">Password</FieldLabel>
                  <a
                    href="#"
                    className="ml-auto inline-block text-sm underline-offset-4 hover:underline"
                  >
                    Forgot your password?
                  </a>
                </div>
                <Input id="password"
                  type="password"
                  value={password}
                  name="password"
                  onChange={(ev) => setPassword(ev.target.value)}
                  required />
              </Field>
              <Field>
                <Button type="submit">Login</Button>
                <Button variant="outline" type="button">
                  Login with Google
                </Button>
                <FieldDescription className="text-center">
                  Don&apos;t have an account? <a href="#">Sign up</a>
                </FieldDescription>
              </Field>
            </FieldGroup>
          </form>
        </CardContent>
      </Card>
    </div>
    )
}

export default LoginModal;