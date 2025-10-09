import { IHttpApi } from './IHttpApi';
import HttpMock from './HttpMock';
import Http from './Http';

export default function getUserApi(): IHttpApi {
  if (import.meta.env.VITE_PROFILE === 'dev') {
    return new HttpMock();
  }
  return new Http();
}