

export type AuthorizationType = {
    accessToken: string
    refreshToken: string
  }
  
  export type LoginResponseType = {
    url: string
  }

  export type AuthType = {
      aud: []
      client_id: string
      exp: number
      ext: {
          name:string,
          avatar:string
      }
      iat: number
      iss: string
      jti: string
      nbf: number
      scp: string[]
      sub: string
  }

  export type LoginPayloadType = {
      user:string
      password:string
      idp:string
  }
  
  export type FetchLoginChallengeType = {
      loginChallenge:string
      state:string
  }