import { AxiosResponse } from 'axios';
import { AuthType, type LoginPayloadType,
    type Modelo, type Recomendations, type SearchPosts,
    type FetchLoginChallengeType,
    AuthorizationType,
    LoginResponseType,
    searchType,
    Posteo
} from '../types';
import { AsyncThunk } from '@reduxjs/toolkit';


export interface IHttpApi {
    fetchLoginChallenge: AsyncThunk<FetchLoginChallengeType, void, object>;
    login: AsyncThunk<AxiosResponse<AuthorizationType>,LoginPayloadType, object>;
    loginGoogle: AsyncThunk<AxiosResponse<LoginResponseType>,void, object>;
    logout: AsyncThunk<AxiosResponse<string>,void, object>;
    getAuthenticated: AsyncThunk<AxiosResponse<AuthType>, void, object>;
    getRecomendations(userId:string):Promise<AxiosResponse<Recomendations[]>> 
    searchPosts(search:searchType):Promise<AxiosResponse<SearchPosts[]>> 
    getModelo(modelo:string):Promise<AxiosResponse<Modelo>>
    getModelos():Promise<AxiosResponse<string[]>>
    sendPost(posteo:Posteo):Promise<AxiosResponse<string>> 
    getPosteos(modelo?:string):Promise<AxiosResponse<Posteo[]>>
    signUp(user:string,password:string):Promise<AxiosResponse<string>>
}