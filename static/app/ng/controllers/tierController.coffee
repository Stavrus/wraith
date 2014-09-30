angular.module('wraith.controllers')

.controller('TierCtrl', ['$scope', 'tierFactory',
  ($scope, tierFactory) ->

    tierFactory.getTiers()
      .then ((data) ->
        $scope.tiers = data.data.tiers
        for tier in $scope.tiers
          for option in tier.tier_options_attributes
            if option.voted_for
              tier.voted_for = true
        return
      ), ((error) ->
        return
      )

    $scope.vote = (tier, option) ->
      tierFactory.vote(tier, option)
      return

    return
  ])