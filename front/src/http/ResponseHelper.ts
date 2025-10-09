import { AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from 'axios';

export function mockAxiosResponse<T>(
  data: T,
  config: Partial<AxiosRequestConfig> = {}
): AxiosResponse<T> {
  return {
    data,
    status: 200,
    statusText: 'OK',
    headers: {},
    config: config as InternalAxiosRequestConfig,
  };
}