angular.module('wraith.services')

.factory('clanFactory', ['$http', '$rootScope',
  ($http, $rootScope) ->

    urlBase = '/api/v1/clans'
    dataFactory = {}

    dataFactory.getClans = ->
      $http.get(urlBase)

    dataFactory.getClan = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.createClan = (name) ->
      $http.post(urlBase, {name: name})

    dataFactory.leaveClan = (id) ->
      $http.post(urlBase + '/' + id + '/leave')

    dataFactory.invitePlayer = (id) ->
      $http.post(urlBase + '/' + id + '/invite', {user: id})

    dataFactory.kickPlayer = (id) ->
      $http.post(urlBase + '/' + id + '/kick', {user: id})

    return dataFactory
  ])