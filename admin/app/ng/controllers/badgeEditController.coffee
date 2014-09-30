angular.module('wraith.controllers')

.controller('BadgeEditCtrl', ['$scope', '$stateParams', 'badgeFactory',
  ($scope, $stateParams, badgeFactory) ->

    badgeFactory.getBadge($stateParams.id)
      .success (data) ->
        $scope.badge = data.badge
      .error (error) ->
        return

    $scope.save = ->
      badgeFactory.updateBadge($scope.badge)
      return
  ])