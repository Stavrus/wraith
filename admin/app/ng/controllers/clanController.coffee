angular.module('wraith.controllers')

.controller('ClanCtrl', ['$scope', '$filter', 'clanFactory',
  ($scope, $filter, clanFactory) ->
    $scope.form = {}

    clanFactory.getClans()
      .success (data) ->
        $scope.clans = data.clans
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

    $scope.$watchGroup ['clans', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.clans, $scope.form.searchBox)
      return

    return
  ])