angular.module('wraith.controllers')

.controller('MissionEditCtrl', ['$scope', '$stateParams', 'missionFactory', 'teamFactory',
  ($scope, $stateParams, missionFactory, teamFactory) ->
    $scope.teams = []

    # Grab the mission data on load
    missionFactory.getMission($stateParams.id)
      .success (data) ->
        $scope.mission = data.mission
      .error (error) ->
        return

    teamFactory.getTeams()
      .success (data) ->
        $scope.teams = $scope.teams.concat(data.teams)
      .error (error) ->
        return

    $scope.save = ->
      missionFactory.updateMission($scope.mission)
      return
  ])