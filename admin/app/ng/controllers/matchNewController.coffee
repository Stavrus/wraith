angular.module('wraith.controllers')

.controller('MatchNewCtrl', ['$scope', 'matchFactory',
  ($scope, matchFactory) ->
    $scope.match = {}

    $scope.save = ->
      matchFactory.updateMatch($scope.match)
      return
  ])