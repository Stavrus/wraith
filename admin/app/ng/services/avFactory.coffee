angular.module('wraith.services')

.factory('avFactory', ['$http',
  ($http) ->

    urlBase = '/api/v1/antiviri'
    dataFactory = {}

    dataFactory.getAntiviri = ->
      $http.get(urlBase)

    dataFactory.getAntivirus = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.updateAntivirus = (antivirus) ->
      obj = {antivirus: antivirus}
      $http.put(urlBase + '/' + antivirus.id, obj)

    dataFactory.addNewAvs = (number) ->
      obj = {quantity: number}
      $http.post(urlBase, obj)

    return dataFactory
  ])