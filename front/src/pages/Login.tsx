import { useState, useEffect } from 'react'
import {  } from '../store/hooks'

const Login = () => {
  const [user, setUser ] = useState<string>("")
  const [ password, setPassword ] = useState<string>("")
  const [ loginChallenge, setLoginChallenge ] = useState<string>("")
  const [ state, setState ] = useState<string>("")
  useEffect(() => {
    const loginChallenge = sessionStorage.getItem("login_challenge")
    const stateVerification = sessionStorage.getItem("state")
    if(loginChallenge && stateVerification) {
      setLoginChallenge(loginChallenge)
      setState(stateVerification)
    }
}, [])
  return (<form style={{maxWidth: '330px', margin: 'auto'}} className="form-signin mt-5"
  action={`/bff/login?login_challenge=${loginChallenge}&state=${state}&idp=internal`} method="POST">
            <h1 className="h3 mb-3 fw-normal">Please sign in</h1>
            <div className="form-floating">
              <input type="input" className="form-control" name="user"
                value={user} onChange={e=>setUser(e.target.value)}
                id="floatingInput" placeholder="name@example.com"/>
              <label htmlFor="floatingInput">Email address</label>
            </div>
            <div className="form-floating">
              <input type="password" className="form-control" id="floatingPassword" name="password"
                value={password} onChange={e=>setPassword(e.target.value)}
                placeholder="Password"/>
              <label htmlFor="floatingPassword">Password</label>
            </div>
            <button className="btn btn-primary w-100 py-2 mt-2" type="submit">Sign in</button>
        </form>)
}

export default Login;