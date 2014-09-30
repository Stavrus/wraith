angular.module('wraith.controllers')

.controller('HeaderCtrl', ['$scope', '$location',
  ($scope, $location) ->
    $scope.active = false

    # TODO: Implement OAUTH login system
    $scope.logIn = ->
      $scope.active = !$scope.active

    $scope.home = ->
      $location.path('/')

    $scope.rulesIndex = ->
      $location.path('/rules')

    $scope.playersIndex = ->
      $location.path('/players')

    $scope.tagsIndex = ->
      $location.path('/tags')

    $scope.tagsNew = ->
      $location.path('/tags/new')
  ])