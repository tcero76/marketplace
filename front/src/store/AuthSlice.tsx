import { createSlice } from "@reduxjs/toolkit"
import getUserApi  from "../http/HttpFactory"

type User = {
    userId: string
    nombre: string
    scopes: string[]
    isAuthenticated: boolean
    avatar: string
    loginChallenge: string
    state: string
}

const initialState:User = {
    userId: '',
    nombre: '',
    scopes: [],
    isAuthenticated: false,
    avatar: '',
    loginChallenge: '',
    state: ''
}

export const authSlice = createSlice({
    name: 'auth',
    initialState,
    reducers: {
        redirectLogin: () => {
            const loginChallenge = sessionStorage.getItem("login_challenge")
            const stateVerification = sessionStorage.getItem("state")
            window.location.href = `http://localhost:8080/login?login_challenge=${loginChallenge}&state=${stateVerification}`
        }
    },
    extraReducers: (builder) => {
        builder.addCase(getUserApi().getAuthenticated.fulfilled, (state, action) => {
            const {sub, scp, ext} = action.payload.data
            state.nombre = ext.name
            state.scopes = scp
            state.userId = sub
            state.avatar = ext.avatar
            state.isAuthenticated = true
        })
        .addCase(getUserApi().fetchLoginChallenge.fulfilled, (state, action) => {
            sessionStorage.setItem("login_challenge", action.payload.loginChallenge);
            sessionStorage.setItem("state", action.payload.state);
            state.loginChallenge = action.payload.loginChallenge;
            state.state = action.payload.state;
        })
        .addCase(getUserApi().login.fulfilled, (_,action) => {
            if(action.payload.data.accessToken !== undefined || action.payload.data.refreshToken !== undefined) {
                sessionStorage.setItem("Access_Token", action.payload.data.accessToken);
                sessionStorage.setItem("Refresh_Token", action.payload.data.refreshToken);
                window.location.href = '/home';
            }
        })
        .addCase(getUserApi().loginGoogle.fulfilled, (_,action) => {
            if (action.payload.data.url !== undefined) {
                window.location.href = action.payload.data.url;
            }   
        })
        .addCase(getUserApi().logout.fulfilled, (state) => {
            sessionStorage.removeItem("Access_Token")
            sessionStorage.removeItem("Refresh_Token")
            sessionStorage.removeItem("login_challenge")
            state.userId = ''
            state.nombre = ''
            state.scopes = []
            state.isAuthenticated = false
            state.avatar = ''
            state.loginChallenge = ''
            state.state = ''
        })
        .addCase(getUserApi().refresh.fulfilled, (_,action) => {
            sessionStorage.setItem("Access_Token", action.payload.data.accessToken)
        });
    }
})

export const { redirectLogin } = authSlice.actions;