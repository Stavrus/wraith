angular.module('wraith.controllers')

.controller('MissionCtrl', ['$scope', '$filter', 'missionFactory', 'teamFactory',
  ($scope, $filter, missionFactory, teamFactory) ->
    $scope.form = {}
    $scope.teams = [{id: 0, name: 'All'}]
    $scope.filteredData = []

    missionFactory.getMissions()
      .then ((data) ->
        $scope.missions = data.data.missions
        return
      ), ((error) ->
        return
      )

    teamFactory.getTeams()
      .success (data) ->
        $scope.teams = $scope.teams.concat(data.teams)
      .error (error) ->
        return

    $scope.currentPage = 0
    $scope.pageSize = 10

    $scope.decrementPage = ->
      unless $scope.currentPage == 0
        $scope.currentPage -= 1

    $scope.incrementPage = ->
      unless $scope.currentPage >= $scope.filteredData.length / $scope.pageSize - 1
        $scope.currentPage += 1

    $scope.numberOfPages = ->
      if $scope.filteredData
        Math.ceil($scope.filteredData.length / $scope.pageSize)
      else
        0

    $scope.$watchGroup ['missions'], () ->
      $scope.filteredData = $scope.missions
      return

    return
  ])