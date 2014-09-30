angular.module('wraith.controllers')

.controller('HeaderCtrl', ['$scope', '$location',
  ($scope, $location) ->

    # Dev Proxy won't let an html href attribute perform the redirect
    $scope.home = ->
      window.location.href = '/'

  ])