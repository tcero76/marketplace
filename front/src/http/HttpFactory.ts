import { IHttpApi } from './IHttpApi';
import HttpMock from './HttpMock';
import Http from './Http';

export default function getUserApi(): IHttpApi {
  const mock = import.meta.env.VITE_MOCK === "true";
  if (mock) {
    return new HttpMock();
  }
  return new Http();
}