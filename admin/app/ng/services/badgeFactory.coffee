angular.module('wraith.services')

.factory('badgeFactory', ['$http',
  ($http) ->

    urlBase = '/api/v1/badges'
    dataFactory = {}

    dataFactory.getBadges = ->
      $http.get(urlBase)

    dataFactory.getBadge = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.updateBadge = (badge) ->
      obj = {badge: badge}
      $http.put(urlBase + '/' + badge.id, obj)
      
    return dataFactory
  ])