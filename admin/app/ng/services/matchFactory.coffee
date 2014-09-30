angular.module('wraith.services')

.factory('matchFactory', ['$http', '$rootScope', '$q'
  ($http, $rootScope, $q) ->

    urlBase = '/api/v1/matches'
    dataFactory = {}

    $rootScope.activeMatch = {}
    activeMatchPromise = $q.defer()
    $rootScope.activeMatchPromise = activeMatchPromise.promise

    $http.get(urlBase + '/active', {cache: true})
      .success (data) ->
        $rootScope.activeMatch = data.match
        activeMatchPromise.resolve()
      .error (error) ->
        activeMatchPromise.resolve()
        return

    dataFactory.getMatches = ->
      $http.get(urlBase)

    dataFactory.getMatch = (id) ->
      $http.get(urlBase + '/' + id)

    dataFactory.updateMatch = (match) ->
      if match.id
        $http.put(urlBase + '/' + match.id, {match: match})
          .success (data) ->
            Messenger().post 'Save successful.'
          .error (error) ->
            Messenger().post 'Save failed.'
      else
        $http.post(urlBase, {match: match})
          .success (data) ->
            Messenger().post 'Save successful.'
          .error (error) ->
            Messenger().post 'Save failed.'

    return dataFactory
  ])