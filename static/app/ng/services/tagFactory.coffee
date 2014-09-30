angular.module('wraith.services')

.factory('tagFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/tags'
    dataFactory = {}

    dataFactory.getTags = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    return dataFactory
  ])