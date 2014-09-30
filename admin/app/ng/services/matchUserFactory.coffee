angular.module('wraith.services')

.factory('matchUserFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/match_users'
    dataFactory = {}

    dataFactory.getMatchUsers = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    dataFactory.getMatchUser = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.getActiveMatchUserByUser = (id) ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch + '&user=' + id)

    dataFactory.updateMatchUser = (user) ->
      obj = {match_user: user}
      $http.put(urlBase + '/' + user.id, obj)

    dataFactory.setPrinted = ->
      $http.post(urlBase + '/print')

    return dataFactory
  ])