import { IHttpApi } from './IHttpApi';
import HttpMock from './HttpMock';
import Http from './Http';

export default function getUserApi(): IHttpApi {
  return import.meta.env.VITE_MOCK === "true"? new HttpMock():new Http()
}