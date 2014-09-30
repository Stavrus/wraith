angular.module('wraith.services')

.factory('matchUserFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/match_users'
    dataFactory = {}

    dataFactory.getMatchUsers = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    dataFactory.getHumans = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch + '&team=1')

    dataFactory.getZombies = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch + '&team=2')

    dataFactory.getMatchUser = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.getActiveMatchUserByUser = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch + '&user=' + $rootScope.user.id)

    return dataFactory
  ])