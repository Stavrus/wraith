angular.module('wraith.controllers')

.controller('MatchCtrl', ['$scope', '$filter', 'matchFactory',
  ($scope, $filter, matchFactory) ->
    $scope.form = {}

    matchFactory.getMatches()
      .success (data) ->
        $scope.matches = data.matches
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

    $scope.$watchGroup ['matches', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.matches, $scope.form.searchBox)
      return

    return
  ])