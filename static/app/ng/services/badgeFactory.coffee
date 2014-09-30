angular.module('wraith.services')

.factory('badgeFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/badges'
    dataFactory = {}

    dataFactory.getBadges = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    return dataFactory
  ])