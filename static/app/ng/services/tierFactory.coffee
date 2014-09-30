angular.module('wraith.services')

.factory('tierFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/tiers'
    dataFactory = {}

    dataFactory.getTiers = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    dataFactory.vote = (tier, option) ->
      $http.put(urlBase + '/' + tier + '/' + 'vote', {option: option})

    return dataFactory
  ])