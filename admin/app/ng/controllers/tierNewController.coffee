angular.module('wraith.controllers')

.controller('TierNewCtrl', ['$scope', 'tierFactory',
  ($scope, tierFactory) ->
    $scope.tier = {tier_options_attributes: []}

    $scope.save = ->
      tierFactory.updateTier($scope.tier)
      return

    $scope.addTierOption = ->
      $scope.tier.tier_options_attributes.push({})
  ])