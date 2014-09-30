angular.module('wraith.controllers')

.controller('BadgeCtrl', ['$scope', '$filter', 'badgeUserFactory',
  ($scope, $filter, badgeUserFactory) ->
    $scope.form = {}
    $scope.data = []

    badgeUserFactory.getBadges()
      .then ((data) ->
        $scope.badges = data.data.badge_users
        return
      ), ((error) ->
        return
      )

    $scope.$watchGroup ['badges', 'form.searchBox'], () ->
      $scope.filteredData = $filter('filter')($scope.badges, $scope.form.searchBox)
      return

    return
  ])