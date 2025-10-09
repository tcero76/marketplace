import { useEffect, type MouseEvent, useState, useRef } from 'react';
import { Toast } from 'bootstrap';
import { useAuthDispatch, useAuthSelector} from '../store/hooks.tsx';
import { redirectLogin } from '../store/AuthSlice.tsx';
import getUserApi from '../http/HttpFactory.ts';

const LoginModal: React.FC = () => {
    const refToast = useRef<HTMLDivElement>(null);
    const dispatch = useAuthDispatch();
    const state = useAuthSelector((state) => state.auth);
    const [user, setUser ] = useState<string>("")
    const [ password, setPassword ] = useState<string>("")
    useEffect(() => {
        const toastElement = refToast.current!
        const toast = Toast.getOrCreateInstance(toastElement, { autohide: false })
        if(state.isAuthenticated === false && window.location.pathname !== '/login') {
            toast.show();
            dispatch(getUserApi().fetchLoginChallenge())
        } else {
            toast.hide();
        }
    },[state.isAuthenticated]);
    const onClickClose = () => {
        const toastElement = refToast.current!
        const toast = Toast.getOrCreateInstance(toastElement, { autohide: false })
        toast.hide();
    }
    const onClickAuth = (e:MouseEvent<HTMLAnchorElement, globalThis.MouseEvent>) => {
        e.preventDefault();
        dispatch(redirectLogin("internal"));
    }
    const onClickAuthGoogle = (e:MouseEvent<HTMLAnchorElement, globalThis.MouseEvent>) => {
        e.preventDefault();
        dispatch(getUserApi().loginGoogle());
    }
    const onClickSignUp = (e:MouseEvent<HTMLButtonElement, globalThis.MouseEvent>) => {
        e.preventDefault();
        dispatch(getUserApi().signUp(user, password));
    }
    return (
        <div className="toast-container position-fixed top-0 end-0 p-3">
            <div id="idToastLogin" className="toast rounded-4 shadow" role="alert" aria-live="assertive" aria-atomic="true" style={{ width: '100%', maxWidth: '500px' }} ref={refToast}>
                    <div className="toast-header" style={{ margin: '3rem 3rem 0rem 3rem', borderBottom: 'none' }}>
                        <h1 className="me-auto">Sign up for free</h1>
                        <button type="button" className="btn-close" aria-label="Close" onClick={onClickClose}></button>
                    </div>
                    <div className="toast-body" style={{ margin: '0rem 3rem 3rem 3rem' }}>
                    <form className="">
                        <div className="form-floating mb-3">
                            <input type="email" className="form-control rounded-3" id="floatingInput"
                                value={user} onChange={e=>setUser(e.target.value)}
                            placeholder="name@example.com" />
                            <label htmlFor="floatingInput">Email address</label>
                        </div>
                        <div className="form-floating mb-3">
                            <input type="password" className="form-control rounded-3"
                                value={password} onChange={e=>setPassword(e.target.value)}
                                id="floatingPassword" placeholder="Password" />
                            <label htmlFor="floatingPassword">Password</label>
                        </div>
                        <button
                            className="w-100 mb-2 btn btn-lg rounded-3 btn-primary"
                            onClick={e => onClickSignUp(e)}
                            type="submit">
                                Sign up
                        </button>
                        <small className="text-body-secondary">Si ya tienes cuante clickea
                            <a onClick={e => onClickAuth(e)} href='/#'>acá</a>
                            </small>
                        <hr className="my-4" />
                        <h2 className="fs-5 fw-bold mb-3">Or use a third-party</h2>
                        <a className="w-100 py-2 mb-2 btn btn-outline-primary rounded-3"
                            onClick={e => onClickAuthGoogle(e)} href='/#'>
                            Sign up with Google
                        </a>
                    </form>
                </div>
            </div>
        </div>
    )
}

export default LoginModal;