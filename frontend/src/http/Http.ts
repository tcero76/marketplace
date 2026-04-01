'use client';

import { createAsyncThunk } from '@reduxjs/toolkit';
import axios, { AxiosInstance, AxiosResponse } from "axios"
import { CredencialType, EmbededType, ImagePasteRes, SearchType, type AuthorizationType,
  type AuthType,
  type FetchLoginChallengeType,
  type LoginPayloadType,
  type LoginResponseType,
  type Modelo,
  type Posteo,
  type Recomendations,
  type SearchPosts } from "../types/index"
import { IHttpApi } from './IHttpApi';
import { setAuthenticated } from '../store/AuthSlice';
import { store } from '../store/store';
import { v4 as uuidv4 } from 'uuid';

export class Http implements IHttpApi {
  private _api: AxiosInstance;

  constructor() {
    const api = axios.create({
      baseURL: `${process.env.NEXT_PUBLIC_HOST}/bff`,
    });
    let isRefreshing = false;
    let refreshSubscribers:((newToken:string) => void)[] = [];
    function subscribeTokenRefresh(cb:(newToken:string) => void) {
      refreshSubscribers.push(cb);
    }
    function onRefreshed(newToken:string) {
        refreshSubscribers.forEach((cb) => cb(newToken));
        refreshSubscribers = [];
    }

    api.interceptors.response.use(
      (response) => response,
      async (error) => {
        const originalRequest = error.config;
        if (error.response?.status === 401 && !originalRequest._retry) {  
          originalRequest._retry = true;
          if (!isRefreshing) {
            isRefreshing = true;
            try {
              const res = await axios.post(`${process.env.NEXT_PUBLIC_HOST}/bff/refresh`, {});
              const newAccessToken = res.data.accessToken;
              await sessionStorage.setItem("Access_Token", newAccessToken);
              store.dispatch(setAuthenticated(true))
              onRefreshed(newAccessToken);
              isRefreshing = false;
              return api(originalRequest);
            } catch (refreshErr) {
              store.dispatch(setAuthenticated(false))
              isRefreshing = false;
              sessionStorage.removeItem("Access_Token");
              // dispatch(login())
              return Promise.reject(refreshErr);
            }
          }
          return new Promise((resolve) => {
            subscribeTokenRefresh((newToken:string) => {
              originalRequest.headers.Authorization = `Bearer ${newToken}`;
              resolve(api(originalRequest));
            });
          });
        }
    
        return Promise.reject(error);
      }
    );
    api.interceptors.request.use((config) => {
      const token = sessionStorage.getItem("Access_Token");
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    });
    this._api = api;
  }

  private AuthUrl(stateVerification:string):string {
    let authUrl = `${process.env.NEXT_PUBLIC_HOST}`
    authUrl += `/hydra/oauth2/auth?client_id=${process.env.VITE_CLIENT_ID}`
    authUrl += `&response_type=code&scope=openid offline mediamtx:stream`
    authUrl += `&state=${stateVerification}`
    authUrl +=  `&redirect_uri=${process.env.NEXT_PUBLIC_HOST}/bff/callback`
    return authUrl;
  }

  fetchLoginChallenge = createAsyncThunk<FetchLoginChallengeType,void, object>(
    '/hydra/oauth2/auth',
    async ():Promise<FetchLoginChallengeType>  => {
      const stateVerification = uuidv4();
      const resp = await axios.get(this.AuthUrl(stateVerification));
      const params = new URLSearchParams(new URL(resp.request.responseURL).search);
      const loginChallenge = params.get("login_challenge") ?? "";
      return { loginChallenge:loginChallenge , state: stateVerification};
    });

  getAuthenticated = createAsyncThunk<AxiosResponse<AuthType>>(
    '/bff/getAuthentication',
    async ():Promise<AxiosResponse<AuthType>> => {
        return await this._api
            .get(`${process.env.NEXT_PUBLIC_HOST}/bff/getAuthentication`,
            {
              headers: {
                'Content-Type': 'application/json',
              }
            }
            )
      }
  );

  login = createAsyncThunk<AxiosResponse<AuthorizationType>, LoginPayloadType>(
    '/login',
    async ({user, password }:LoginPayloadType):Promise<AxiosResponse<AuthorizationType>> => {
      let loginUrl = `${process.env.NEXT_PUBLIC_HOST}/bff/login?`
      loginUrl += `login_challenge=${sessionStorage.getItem("login_challenge")}`
      loginUrl += `&state=${sessionStorage.getItem("state")}`
      loginUrl += `&idp=internal`
      return await axios.post(loginUrl, 
        { user, password },
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }
      );
      }
  )

  loginGoogle = createAsyncThunk<AxiosResponse<LoginResponseType>, void>(
    '/loginGoogle',
    async ():Promise<AxiosResponse<LoginResponseType>> => {
      let loginUrl = `${process.env.NEXT_PUBLIC_HOST}/bff/login?`
      loginUrl += `login_challenge=${sessionStorage.getItem("login_challenge")}`
      loginUrl += `&state=${sessionStorage.getItem("state")}`
      loginUrl += `&idp=google`
      return await axios.post(loginUrl, 
        {},
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }
      );
      }
  )

  logout = createAsyncThunk<AxiosResponse<string>, void>(
    '/logout',
    async ():Promise<AxiosResponse<string>> => {
      return await axios.get(`${process.env.NEXT_PUBLIC_HOST}/bff/logout`, 
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${sessionStorage.getItem("Access_Token")}`
          }
        }
      );
    })

  getRecomendations(userId:string): Promise<AxiosResponse<Recomendations[]>> {
    return this._api
    .get(`${process.env.NEXT_PUBLIC_HOST}/bff/usuario/getRecommendations?userId=${userId}`)
  }
  searchPosts(search:SearchType): Promise<AxiosResponse<SearchPosts[]>> {
    return this._api
    .post(`${process.env.NEXT_PUBLIC_HOST}/bff/usuario/searchPosts`,
      { ...search }
    )
  }
  getModelo(modelo:string): Promise<AxiosResponse<Modelo>> {
    return this._api
    .get(`${process.env.NEXT_PUBLIC_HOST}/bff/usuario/getModelo?modelo=${modelo}`)
  }

  getModelos():Promise<AxiosResponse<string[]>> {
    return this._api
      .get(`${process.env.NEXT_PUBLIC_HOST}/bff/usuario/getModelos`)
  }

  getTopics():Promise<AxiosResponse<string[]>> {
    return this._api
      .get(`${process.env.NEXT_PUBLIC_HOST}/bff/usuario/getTopics`)
  }

  sendPost(posteo:Posteo):Promise<AxiosResponse<string>> {
    return this._api
    .post(`${process.env.NEXT_PUBLIC_HOST}/bff/usuario/createPost`,
      { ...posteo }
    )
  } 
  getPosteos(modelo?:string):Promise<AxiosResponse<Posteo[]>> {
    let url = `${process.env.NEXT_PUBLIC_HOST}/bff/usuario/getPosteos`
    if (modelo) {
      url += `?modelo=${modelo}`
    }
    return this._api.get(url)
  }

  signUp = createAsyncThunk<AxiosResponse<string>, CredencialType, object>('signUp',
    async  ({ user, password }: CredencialType) => {
      return await axios.post(`${process.env.NEXT_PUBLIC_HOST}/bff/signup`, 
        { email:user, password },
        {
          headers: {
            'Content-Type': 'application/json'
          }
        }
      );
    }
  )

  onImagePaste = (file: File):Promise<AxiosResponse<ImagePasteRes>> => {
    const formData = new FormData()
    formData.append("image", file)
    return this._api.post("/bff/uploadImage", formData)
  }


    onEmbed(url: string): Promise<AxiosResponse<EmbededType>> {
      return this._api
        .get(`${process.env.NEXT_PUBLIC_HOST}/bff/embeded?url=${url}`)
    }
}