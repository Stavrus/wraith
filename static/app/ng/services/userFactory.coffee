angular.module('wraith.services')

.factory('userFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/users'
    dataFactory = {}

    dataFactory.getUsers = ->
      $http.get(urlBase)

    dataFactory.getUser = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.registerForMatch = (interest) ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.post(urlBase + '/register'+ activeMatch, {oz_interest: interest})

    return dataFactory
  ])