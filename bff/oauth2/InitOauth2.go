package oauth2

import (
	"github.com/tcero76/marketplace/bff/oauth2/cor"
	"github.com/tcero76/marketplace/bff/services"
)

func InitOauth2Handlers(authCacheService services.IAuthCacheService,
	userServices services.IUserService,
	internalAuth *cor.InternalAuth,
	googleAuth *cor.GoogleAuth) (cor.Handler, cor.Handler, cor.Handler) {
	loginHandler := &cor.BaseHandler{
		AuthCacheService: authCacheService,
		UserServices:     userServices,
	}
	loginInternalHandler := &cor.LoginInternalHandler{
		InternalAuth: *internalAuth,
		BaseHandler: cor.BaseHandler{
			AuthCacheService: authCacheService,
			UserServices:     userServices,
		},
	}
	loginGoogleHandler := &cor.LoginGoogleHandler{
		GoogleAuth: *googleAuth,
		BaseHandler: cor.BaseHandler{
			AuthCacheService: authCacheService,
			UserServices:     userServices,
		},
	}

	callbackGoogleHandler := &cor.CallbackGoogleHandler{
		InternalAuth: *internalAuth,
		GoogleAuth:   *googleAuth,
		BaseHandler: cor.BaseHandler{
			AuthCacheService: authCacheService,
			UserServices:     userServices,
		},
	}
	consentHandler := &cor.BaseHandler{
		AuthCacheService: authCacheService,
		UserServices:     userServices,
	}
	consentInternalHandler := &cor.ConsentInternalHandler{
		InternalAuth: *internalAuth,
		BaseHandler: cor.BaseHandler{
			AuthCacheService: authCacheService,
			UserServices:     userServices,
		},
	}
	callbackHandler := &cor.BaseHandler{
		AuthCacheService: authCacheService,
		UserServices:     userServices,
	}
	callbackInternalHandler := &cor.CallbackInternalHandler{
		InternalAuth: *internalAuth,
		BaseHandler: cor.BaseHandler{
			AuthCacheService: authCacheService,
			UserServices:     userServices,
		},
	}

	loginHandler.SetNext(loginInternalHandler)
	loginHandler.SetNext(loginGoogleHandler)
	consentHandler.SetNext(consentInternalHandler)
	callbackHandler.SetNext(callbackInternalHandler)
	callbackHandler.SetNext(callbackGoogleHandler)
	return loginHandler, consentHandler, callbackHandler
}
