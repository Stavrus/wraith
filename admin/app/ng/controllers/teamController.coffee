angular.module('wraith.controllers')

.controller('TeamCtrl', ['$scope', '$location', '$http',
  ($scope, $location, $http) ->
    $http.get('http://localhost:5100/api/v1/teams').success (data) ->
      $scope.data = data
      return

    $scope.getTeam = (id) ->
      $location.path('/teams/' + id)
  ])