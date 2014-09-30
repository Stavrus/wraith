angular.module('wraith.controllers')

.controller('MatchEditCtrl', ['$scope', '$stateParams', 'matchFactory',
  ($scope, $stateParams, matchFactory) ->

    # Grab the mission data on load
    matchFactory.getMatch($stateParams.id)
      .success (data) ->
        $scope.match = data.match
      .error (error) ->
        return

    $scope.save = ->
      matchFactory.updateMatch($scope.match)
      return
  ])