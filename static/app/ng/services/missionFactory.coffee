angular.module('wraith.services')

.factory('missionFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/missions'
    dataFactory = {}

    dataFactory.getMissions = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    return dataFactory
  ])