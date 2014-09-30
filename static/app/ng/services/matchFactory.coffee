angular.module('wraith.services')

.factory('matchFactory', ['$http', '$rootScope', '$q',
  ($http, $rootScope, $q) ->

    urlBase = '/api/v1/matches'
    dataFactory = {}

    $rootScope.activeMatch = {}
    activeMatchPromise = $q.defer()
    $rootScope.activeMatchPromise = activeMatchPromise.promise

    $http.get(urlBase + '/active', {cache: true})
      .success (data) ->
        $rootScope.activeMatch = data.match
        activeMatchPromise.resolve()
      .error (error) ->
        $activeMatchPromise.resolve()
        return

    dataFactory.getMatches = ->
      $http.get(urlBase)

    dataFactory.getMatch = (id) ->
      $http.get(urlBase + '/' + id)

    return dataFactory
  ])