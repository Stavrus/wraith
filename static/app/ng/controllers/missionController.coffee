angular.module('wraith.controllers')

.controller('MissionCtrl', ['$scope', 'missionFactory',
  ($scope, missionFactory) ->

    missionFactory.getMissions()
      .then ((data) ->
        $scope.missions = data.data.missions
        return
      ), ((error) ->
        return
      )

    return
  ])