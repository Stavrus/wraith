angular.module('wraith.controllers')

.controller('TierEditCtrl', ['$scope', '$stateParams', 'tierFactory',
  ($scope, $stateParams, tierFactory) ->
    $scope.currentPage = 0
    $scope.tier = {tier_options_attributes: []}

    tierFactory.getTier($stateParams.id)
      .success (data) ->
        $scope.tier = data.tier
      .error (error) ->
        return

    $scope.$watch 'tier', ->
      $scope.pageSize = $scope.tier.tier_options_attributes.length
      return

    $scope.save = ->
      tierFactory.updateTier($scope.tier)
      return

    $scope.addTierOption = ->
      $scope.tier.tier_options_attributes.push({})

    $scope.xFunction = ->
      (d) -> d.name

    $scope.yFunction = ->
      (d) -> d.votes

    return
  ])