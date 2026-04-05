import { AuthorizationType, AuthType, CredencialType, EmbededType,
  FetchLoginChallengeType, IdxProps, ImagePasteRes, LoginPayloadType, LoginResponseType, Modelo, Posteo,
  SearchPosts, SearchType, 
  Ts,
  Tses} from "@/types";
import { createApi } from "@reduxjs/toolkit/query/react";
import { baseQueryWithRefresh } from "./baseQueryWithRefresh"
import { fetchLoginChallenge, logout } from "@/store/AuthSlice";
import { baseHydraQuery } from "./baseQuery";
import { Servicios } from "@/types/servicios";

export const api = createApi({
  reducerPath: "api",
  baseQuery: baseQueryWithRefresh,
  tagTypes: ['Posteos'],
  endpoints: (builder) => {
    return (
      {
      getAuthenticated: builder.query<AuthType, void>({
        query: () => ({
          url: `/getAuthentication`,
          method: 'GET',
          headers: {
                  'Content-Type': 'application/json',
                }
        })
      }),
      login: builder.mutation<AuthorizationType, LoginPayloadType>({
        query: ({ user, password }:LoginPayloadType) => ({
          url: `/login?` +
            `login_challenge=${sessionStorage.getItem("login_challenge")}` +
            `&state=${sessionStorage.getItem("state")}` +
            `&idp=internal`,
          method: 'POST',
          body: { user, password }, 
          headers:  {
              'Content-Type': 'application/json'
            }
        }),
        async onQueryStarted(_, { dispatch, queryFulfilled }) {
          try {
            const { data, meta } = await queryFulfilled
            if (data.accessToken) {
              sessionStorage.setItem("Access_Token", data.accessToken)
              sessionStorage.removeItem("login_challenge")
              sessionStorage.removeItem("state")
            }
          } catch (err) {
            console.error("Login error:", err)
          }
        }
      }),
      logout: builder.mutation<string, void>({
        query: () => ({
          url: `${process.env.NEXT_PUBLIC_HOST}/bff/logout`,
          method: 'GET',
          headers: {
              'Content-Type': 'application/json',
            }
        }),
        async onQueryStarted(_, { dispatch, queryFulfilled }) {
              await queryFulfilled  
              dispatch(logout())
        }
      }),
      loginGoogle: builder.query<LoginResponseType, void>({
        query: () => ({
          url: `${process.env.NEXT_PUBLIC_HOST}/bff/login?` +
            `login_challenge=${sessionStorage.getItem("login_challenge")}` +
            `&state=${sessionStorage.getItem("state")}` +
            `&idp=google`,
          method: 'POST',
          headers: {
              'Content-Type': 'application/json'
            }
        }),
        async onQueryStarted(_, { dispatch, queryFulfilled }) {
          const { data } = await queryFulfilled
          if (data.url !== undefined) {
              window.location.href = data.url;
          }   
        }
      }),
      signUp: builder.query<string, CredencialType>({
        query: ({ user, password }: CredencialType) => ({
          url: `${process.env.NEXT_PUBLIC_HOST}/bff/signup`,
          method: 'POST',
          body: { email:user, password },
          headers: {
              'Content-Type': 'application/json'
            }
        })
      }),
      searchTs: builder.query<SearchPosts[],SearchType>({
        query: (search:SearchType) => ({ 
          url:`/usuario/searchTs`,
          method: 'POST',
          body: search
         })
        }),
      getModelo: builder.query<Modelo, string>({
        query: (modelo:string) => `${process.env.NEXT_PUBLIC_HOST}/bff/usuario/getModelo?modelo=${modelo}`
      }),
      getModelos: builder.query<string[], void>({
        query: () => `/usuario/getModelos`
      }),
      getTs: builder.query<Ts, string>({
        query: (ts:string) => `/usuario/getTs?ts=${ts}`
      }),
      getTsesIdx: builder.query<IdxProps[], void>({
        query: () => `/usuario/getRecommendations`
      }),
      getTses: builder.query<Tses[], void>({
        query: () => `/usuario/getTses`
      }),
      getTopics: builder.query<Servicios[], void>({
        query: () => `/usuario/getTopics`
      }),
      sendPost: builder.mutation<string, Posteo>({
        query: (posteo:Posteo) => ({
          url: `/usuario/createPost`,
          method: 'POST',
          body: posteo
         }),
        invalidatesTags: ['Posteos']
        }),
      getPosteos: builder.query<Posteo[], string>({
        query: (nombre?:string) => ({
          url: `/usuario/getPosteos`,
          method: 'GET',
          params: nombre ? { nombre } : undefined
        }),
        providesTags: ['Posteos'],
      }),
      onImagePaste: builder.mutation<ImagePasteRes, File>({
        query: (file: File) => {
          const formData = new FormData()
          formData.append("image", file)
          return {
            url: "/uploadImage",
            method: "POST",
            body: formData
          }
        }
      }),
      onEmbed: builder.query<EmbededType, string>({
        query: (url: string) => ({
          url: `${process.env.NEXT_PUBLIC_HOST}/bff/embeded`,
          method: "GET",
          params: { url }
        })
      }),
      }
    );
  }
});

export const hydra = createApi({
  reducerPath: "hydra",
  baseQuery: baseHydraQuery,
  endpoints:(builder) => {
    return (
      {
      fetchLoginChallenge: builder.mutation<FetchLoginChallengeType, string>({
        query: (state) => ({
          url: `/hydra/oauth2/auth?client_id=${process.env.NEXT_PUBLIC_CLIENT_ID}` +
          `&response_type=code&scope=openid offline mediamtx:stream` +
          `&state=${state}` +
           `&redirect_uri=${process.env.NEXT_PUBLIC_HOST}/bff/callback`,
          method: 'GET'
        }),
        async onQueryStarted(state, { dispatch, queryFulfilled }) {
          const { data, meta } = await queryFulfilled
          console.log("🚀 ~ meta:", meta)
          console.log("🚀 ~ data:", data)
          // const responseUrl = (meta as { response: Response })?.response?.url ?? ""
          // const params = new URLSearchParams(new URL(responseUrl).search);
          // const loginChallenge = params.get("login_challenge") ?? "";
          dispatch(fetchLoginChallenge({ loginChallenge: '' , state}));
        }
      })
    })}
})

export const {
  useLoginMutation,
  useLoginGoogleQuery,
  useLogoutMutation,
  useGetAuthenticatedQuery,
  useGetTsesIdxQuery,
  useGetTsesQuery,
  useSearchTsQuery,
  useGetModeloQuery,
  useGetModelosQuery,
  useGetTsQuery,
  useGetTopicsQuery,
  useSendPostMutation,
  useGetPosteosQuery,
  useSignUpQuery,
  useOnEmbedQuery,
  useOnImagePasteMutation,
} = api

export const {
  useFetchLoginChallengeMutation
} = hydra