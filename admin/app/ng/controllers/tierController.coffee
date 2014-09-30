angular.module('wraith.controllers')

.controller('TierCtrl', ['$scope', '$filter', 'tierFactory',
  ($scope, $filter, tierFactory) ->
    $scope.form = {}

    tierFactory.getTiers()
      .then ((data) ->
        $scope.tiers = data.data.tiers
        return
      ), ((error) ->
        return
      )

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

    $scope.numberOfPages = ->
      if $scope.filteredData
        Math.ceil($scope.filteredData.length / $scope.pageSize)
      else
        0

    $scope.$watchGroup ['tiers', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.tiers, $scope.form.searchBox)
      return

    return
  ])