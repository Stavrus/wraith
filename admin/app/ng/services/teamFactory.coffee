angular.module('wraith.services')

.factory('teamFactory', ['$http',
  ($http) ->

    urlBase = '/api/v1/teams'
    dataFactory = {}

    dataFactory.getTeams = ->
      $http.get(urlBase)

    return dataFactory
  ])