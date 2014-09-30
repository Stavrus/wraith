angular.module('wraith.controllers')

.controller('TeamEditCtrl', ['$scope', '$location', '$routeParams', '$http',
  ($scope, $location, $routeParams, $http) ->
    $http.get('http://localhost:5100/api/v1/teams/' + $routeParams.id).success (data) ->
      $scope.data = data
      return

    $scope.cancel = () ->
      $location.path('/teams')

    $scope.save = () ->
      $http.put('http://localhost:5100/api/v1/teams/' + $routeParams.id, $scope.data).success (data) ->
        return
  ])