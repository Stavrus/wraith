angular.module('wraith.controllers')

.controller('UserCtrl', ['$scope', '$filter', 'userFactory',
  ($scope, $filter, userFactory) ->
    $scope.form = {}
    $scope.users = []

    userFactory.getUsers()
      .success (data) ->
        $scope.users = data.users
      .error (error) ->
        return

    $scope.currentPage = 0
    $scope.pageSize = 10

    $scope.decrementPage = ->
      unless $scope.currentPage == 0
        $scope.currentPage -= 1

    $scope.incrementPage = ->
      unless $scope.currentPage >= $scope.filteredData.length / $scope.pageSize - 1
        $scope.currentPage += 1

    $scope.numberOfPages = ->
      if $scope.filteredData
        Math.ceil($scope.filteredData.length / $scope.pageSize)
      else
        0

    $scope.$watchGroup ['users', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.users, $scope.form.searchBox)
      return

    return
  ])