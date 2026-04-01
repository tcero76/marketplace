import { fetchBaseQuery } from "@reduxjs/toolkit/query"
import type { RootState } from "@/store/store"

export const baseQuery = fetchBaseQuery({
  baseUrl: "/bff",
  prepareHeaders: (headers, { getState }) => {
      headers.set("Authorization", `Bearer ${sessionStorage.getItem("Access_Token")}`)
    return headers
  }
})

export const baseHydraQuery = fetchBaseQuery({
  baseUrl: "/hydra",
  credentials: "include",
})