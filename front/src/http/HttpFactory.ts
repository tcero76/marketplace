import { IHttpApi } from './IHttpApi';
import HttpMock from './HttpMock';
import Http from './Http';

export default function getUserApi(): IHttpApi {
  if (import.meta.env.VITE_MOCK === true) {
    return new HttpMock();
  }
  return new Http();
}