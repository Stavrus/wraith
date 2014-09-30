angular.module('wraith.services')

.factory('badgeUserFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/badge_users'
    dataFactory = {}

    dataFactory.getBadges = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    return dataFactory
  ])