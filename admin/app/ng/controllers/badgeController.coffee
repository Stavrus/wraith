angular.module('wraith.controllers')

.controller('BadgeCtrl', ['$scope', '$filter', 'badgeFactory',
  ($scope, $filter, badgeFactory) ->
    $scope.form = {}

    badgeFactory.getBadges()
      .success (data) ->
        $scope.badges = data.badges
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

    $scope.$watchGroup ['badges', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.badges, $scope.form.searchBox)
      return

    return
  ])