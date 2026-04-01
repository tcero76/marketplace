import { Mutex } from "async-mutex"
import type {
  BaseQueryFn,
  FetchArgs,
  FetchBaseQueryError
} from "@reduxjs/toolkit/query"

import { baseQuery } from "./baseQuery"
import { logout } from "@/store/AuthSlice"

const mutex = new Mutex()

export const baseQueryWithRefresh: BaseQueryFn<string | FetchArgs, unknown, FetchBaseQueryError> =
 async (args, api, extraOptions) => {
  await mutex.waitForUnlock()
  let result = await baseQuery(args, api, extraOptions)
  if (result.error && result.error.status === 401) {
    if (!mutex.isLocked()) {
      const release = await mutex.acquire()
      try {
        const refreshResult = await baseQuery(
          {
            url: "/auth/refresh",
            method: "POST"
          },
          api,
          extraOptions
        )
        if (refreshResult.data) {
          const data = refreshResult.data as { accessToken: string }
          sessionStorage.setItem("Access_Token",  data.accessToken);
          result = await baseQuery(args, api, extraOptions)
        } else {
          api.dispatch(logout())
        }
      } finally {
        release()
      }
    } else {
      await mutex.waitForUnlock()
      result = await baseQuery(args, api, extraOptions)
    }
  }
  return result
}