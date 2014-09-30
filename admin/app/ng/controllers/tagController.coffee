angular.module('wraith.controllers')

.controller('TagCtrl', ['$scope', '$location', '$http',
  ($scope, $location, $http) ->
    $http.get('http://localhost:5100/api/v1/tags').success (data) ->
      $scope.data = data
      return

    $scope.getUser = (id) ->
      $location.path('/tags/' + id)
  ])