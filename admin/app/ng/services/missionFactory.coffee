angular.module('wraith.services')

.factory('missionFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/missions'
    dataFactory = {}

    dataFactory.getMissions = ->
      $rootScope.activeMatchPromise.then ->
        activeMatch = '?match=' + $rootScope.activeMatch.id
        $http.get(urlBase + activeMatch)

    dataFactory.getMission = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.updateMission = (mission) ->
      if mission.id
        $http.put(urlBase + '/' + mission.id, {mission: mission})
      else
        $http.post(urlBase, {mission: mission})

    return dataFactory
  ])