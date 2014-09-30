# Frankenstein-ish merge of ng-token-auth and oauth-ng.
# Taking the best of both and putting them together.

# ng-token-auth: DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE Version 2
# oauth-ng: MIT license

angular.module('wraith-auth', ['ngStorage'])
  .provider('$auth', ->
    config =
      apiUrl:                  '/api/v1'
      signInUrl:               '/auth/sign_in'
      signOutUrl:              '/auth/sign_out'
      profileUrl:              '/auth/profile'
      authScope:               'email'
      redirectUrl:             'http://localhost:5000/'

      tokenFormat:
        "X-USER-TOKEN": "{{ token }}"
        "X-USER_EMAIL": "{{ email }}"

      parseExpiry: (headers) ->
        # convert from ruby time (seconds) to js time (millis)
        (parseInt(headers['auth_expires'], 10) * 1000) || null

      handleTokenValidationResponse: (resp) -> resp

      authProviderPaths:
        google:    'https://accounts.google.com/o/oauth2/auth'

      authProviderIds:
        google:    '357186498019.apps.googleusercontent.com'

    return {
      configure: (params) ->
        angular.extend(config, params)

      $get: ['$http', '$q', '$location', '$window', '$timeout','$rootScope', '$interpolate', '$localStorage',
        ($http, $q, $location, $window, $timeout, $rootScope, $interpolate, $localStorage) =>
          header:            null
          dfd:               null
          config:            config
          user:              {}
          listener:          null

          initialize: ->
            @addScopeMethods()
            # Hash no longer available, grab it by a different means
            params = @getTokenFromString($window.location.pathname.slice(1))
            if params && params.access_token
              @initServerAuthProcess(params.access_token)

          cancel: (reason) ->
            if @t?
              $timeout.cancel(@t)

            if @dfd?
              @rejectDfd(reason)

            return $timeout((=> @t = null), 0)

          destroy: ->
            @cancel()

          addScopeMethods: ->
            # bind global user object to auth user
            $rootScope.user = @user

            # template access to authentication method
            $rootScope.authenticate  = (provider) => @authenticate(provider)

            # template access to view actions
            $rootScope.signOut       =            => @signOut()

            # check to see if user is returning user
            @validateUser()

          # send requests for credentials until api auth callback page responds.
          authenticate: (provider) ->
            unless @dfd?
              @initDfd()
              @initAuthProcess(provider)

            @dfd.promise

          # If on the google callback, grab the access token
          getTokenFromString: (hash) ->
            params = {}
            if hash
              for item in hash.split('&')
                param  = item.split('=')
                key    = param[0]
                value  = param[1]
                params[key] = value

              if params.access_token || params.error
                return params

          # get the access token from the server using the provider token
          initServerAuthProcess: (token) ->
            unless @dfd?
              @initDfd(this)
            me = this
            $http.post(@apiUrl() + config.signInUrl, {token: token})
              .success (resp) ->
                me.handleValidAuth(resp.user, me)
              .error (error) ->
                return
            @dfd.promise

          # redirect to authentication provider
          initAuthProcess: (provider) ->
            authUrl = @buildAuthUrl(provider)
            $window.location.href = authUrl

          buildAuthUrl: (provider) ->
            authUrl = config.authProviderPaths[provider]
            authUrl += '?response_type=token'
            authUrl += '&client_id='
            authUrl += encodeURIComponent(config.authProviderIds[provider])
            authUrl += '&redirect_uri='
            authUrl += encodeURIComponent(config.redirectUrl)
            authUrl += '&scope='
            authUrl += config.authScope

          # this needs to happen after a reflow so that the promise
          # can be rejected properly before it is destroyed.
          resolveDfd: (instance=this) ->
            if instance.dfd
              instance.dfd.resolve({id: instance.user.id})
              $timeout((=>
                instance.dfd = null
                $rootScope.$digest() unless $rootScope.$$phase
              ), 0)

          # this is something that can be returned from 'resolve' methods
          # of pages that have restricted access
          validateUser: ->
            unless @dfd?
              @initDfd()

              unless @headers and @user.id
                if $localStorage.auth_headers
                  @headers = $localStorage.auth_headers

                if @headers
                  @validateToken()
                # new user session. will redirect to login
                else
                  @rejectDfd({
                    reason: 'Unauthorized'
                    errors: ['No credentials']
                  })
                  $rootScope.$broadcast('auth:invalid')
              else
                # user is already logged in
                @resolveDfd()

            @dfd.promise

          # confirm that user's auth token is still valid.
          validateToken: () ->
            if !@tokenHasExpired() && $localStorage.auth_headers['X-USER-TOKEN']
              me = this
              $http.get(@apiUrl() + config.profileUrl)
                .success((resp) =>
                  authData = config.handleTokenValidationResponse(resp.user)
                  @handleValidAuth(authData, me)

                  $rootScope.$broadcast('auth:validation-success', @user)
                )
                .error((data) =>
                  $rootScope.$broadcast('auth:validation-error', data)

                  @rejectDfd({
                    reason: 'unauthorized'
                    errors: data.errors
                  })
                )
            else
              @rejectDfd({
                reason: 'unauthorized'
                errors: ['Expired credentials']
              })

          # don't bother checking known expired headers
          tokenHasExpired: ->
            expiry = @getExpiry()

            now = new Date().getTime()

            if @headers and expiry
              return (expiry and expiry < now)
            else
              return null

          # get expiry by method provided in config
          getExpiry: ->
            config.parseExpiry(@headers)

          # this service attempts to cache auth tokens, but sometimes we
          # will want to discard saved tokens. examples include:
          # 1. login failure
          # 2. token validation failure
          # 3. user logs out
          invalidateTokens: ->
            # cannot delete user object for scoping reasons. instead, delete
            # all keys on object.
            delete @user[key] for key, val of @user

            # setting this value to null will force the validateToken method
            # to re-validate credentials with api server when validate is called
            @headers = null

            # kill cookies, otherwise session will resume on page reload
            delete $localStorage.auth_headers

          # destroy auth token on server, destroy user auth credentials
          signOut: ->
            $http.delete(@apiUrl() + config.signOutUrl)
              .success((resp) =>
                @invalidateTokens()
                $rootScope.$broadcast('auth:logout-success')
              )
              .error((resp) =>
                $rootScope.$broadcast('auth:logout-error', resp)
              )

          # handle successful authentication
          handleValidAuth: (user, instance=this, setHeader=false) ->
            # cancel any pending postMessage checks
            $timeout.cancel(instance.t) if instance.t?

            # must extend existing object for scoping reasons
            angular.extend instance.user, user

            # postMessage will not contain header. must save headers manually.
            instance.setAuthHeaders(instance.buildAuthHeaders({
              token:    instance.user.authentication_token
              email:    instance.user.email
              expires:  instance.user.auth_expires
            }, instance))

            # fulfill promise
            instance.resolveDfd(instance)

          # auth token format. consider making this configurable
          buildAuthHeaders: (ctx) ->
            headers = {}

            for key, val of config.tokenFormat
              headers[key] = $interpolate(val)(ctx)

            return headers

          # persist authentication token
          setAuthHeaders: (headers, instance=this) ->
            instance.headers = angular.extend((instance.headers || {}), headers)
            $localStorage.auth_headers = instance.headers

          initDfd: (instance=this)->
            instance.dfd = $q.defer()

          # failed login. invalidate auth header and reject promise.
          # defered object must be destroyed after reflow.
          rejectDfd: (reason) ->
            @invalidateTokens()
            if @dfd?
              @dfd.reject(reason)

              # must nullify after reflow so promises can be rejected
              $timeout((=> @dfd = null), 0)

          apiUrl: ->
            config.apiUrl
      ]
    }
  )


  # each response will contain auth headers that have been updated by
  # the server. copy those headers for use in the next request.
  .config(['$httpProvider', ($httpProvider) ->
    # this is ugly...
    # we need to configure an interceptor (must be done in the configuration
    # phase), but we need access to the $http service, which is only available
    # during the run phase. the following technique was taken from this
    # stackoverflow post:
    # http://stackoverflow.com/questions/14681654/i-need-two-instances-of-angularjs-http-service-or-what
    $httpProvider.interceptors.push ['$injector', ($injector) ->
      request: (req) ->
        $injector.invoke ['$http', '$auth',  ($http, $auth) ->
          if req.url.match($auth.config.apiUrl)
            for key, val of $auth.headers
              req.headers[key] = val
        ]

        return req

      response: (resp) ->
        $injector.invoke ['$http', '$auth', ($http, $auth) ->
          newHeaders = {}

          for key, val of $auth.config.tokenFormat
            if resp.headers(key)
              newHeaders[key] = resp.headers(key)


          $auth.setAuthHeaders(newHeaders)
        ]

        return resp
    ]

    # define http methods that may need to carry auth headers
    httpMethods = ['get', 'post', 'put', 'patch', 'delete']

    # disable IE ajax request caching for each of the necessary http methods
    angular.forEach(httpMethods, (method) ->
      $httpProvider.defaults.headers[method] ?= method
      $httpProvider.defaults.headers[method]['If-Modified-Since'] = '0'
    )
  ])

  .run(['$auth', '$window', '$rootScope', ($auth, $window, $rootScope) ->
    $auth.initialize()
  ])

# ie8 and ie9 require special handling
window.isOldIE = ->
  out = false
  nav = navigator.userAgent.toLowerCase()
  if nav and nav.indexOf('msie') != -1
    version = parseInt(nav.split('msie')[1])
    if version < 10
      out = true

  out
