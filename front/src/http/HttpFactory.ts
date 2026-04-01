'use client';

import { IHttpApi } from './IHttpApi';
import HttpMock from './HttpMock';
import { Http } from './Http';

export default function getUserApi(): IHttpApi {
  // return (process.env.NEXT_PUBLIC_MOCK === true) ? new HttpMock() : new Http();
  return new HttpMock()
}