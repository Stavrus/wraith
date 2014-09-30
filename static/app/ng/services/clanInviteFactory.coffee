angular.module('wraith.services')

.factory('clanInviteFactory', ['$http',
  ($http) ->

    urlBase = '/api/v1/clan_invites'
    dataFactory = {}

    dataFactory.getClanInvites = ->
      $http.get(urlBase)

    dataFactory.acceptInvite = (id) ->
      $http.post(urlBase + '/' + id + '/accept')

    return dataFactory
  ])