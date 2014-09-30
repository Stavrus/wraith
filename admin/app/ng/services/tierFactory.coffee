angular.module('wraith.services')

.factory('tierFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/tiers'
    dataFactory = {}

    dataFactory.getTiers = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    dataFactory.getTier = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.updateTier = (tier) ->
      if tier.id
        $http.put(urlBase + '/' + tier.id, {tier: tier})
      else
        $http.post(urlBase, {tier: tier})

    return dataFactory
  ])