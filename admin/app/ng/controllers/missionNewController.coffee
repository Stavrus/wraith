angular.module('wraith.controllers')

.controller('MissionNewCtrl', ['$scope', '$stateParams', 'missionFactory',
  ($scope, $stateParams, missionFactory) ->
    $scope.mission = {}
    $scope.form = {}

    $scope.teams = [ {id: 1, name: "Humans"}, {id: 2, name: "Zombies"} ]

    $scope.save = ->
      $scope.mission.team_id = $scope.form.selectBox.id
      missionFactory.updateMission($scope.mission)
      return
  ])