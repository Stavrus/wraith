angular.module('wraith.services')

.factory('clanFactory', ['$http',
  ($http) ->

    urlBase = '/api/v1/clans'
    urlUsersBase = 'api/v1/users'
    dataFactory = {}

    dataFactory.getClans = ->
      $http.get(urlBase)

    dataFactory.getClan = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.getClanUsers = (id) ->
      $http.get(urlUsersBase + '?clan=' + id)

    dataFactory.updateClan = (clan) ->
      obj = {clan: clan}
      $http.put(urlBase + '/' + clan.id, obj)

    return dataFactory
  ])