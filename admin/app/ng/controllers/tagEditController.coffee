angular.module('wraith.controllers')

.controller('TagEditCtrl', ['$scope', '$location', '$routeParams', '$http',
  ($scope, $location, $routeParams, $http) ->
    $http.get('http://localhost:5100/api/v1/tags/' + $routeParams.id).success (data) ->
      $scope.data = data
      return

    $scope.cancel = () ->
      $location.path('/tags')

    $scope.save = () ->
      $http.put('http://localhost:5100/api/v1/tags/' + $routeParams.id, $scope.data).success (data) ->
        return
  ])