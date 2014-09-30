angular.module('wraith.services')

.factory('userFactory', ['$http',
  ($http) ->

    urlBase = '/api/v1/users'
    dataFactory = {}

    dataFactory.getUsers = ->
      $http.get(urlBase)

    dataFactory.getUser = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.updateUser = (user) ->
      obj = {user: user}
      $http.put(urlBase + '/' + user.id, obj)

    return dataFactory
  ])