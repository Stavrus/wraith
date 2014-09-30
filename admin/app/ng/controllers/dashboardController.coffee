angular.module('wraith.controllers')

.controller('DashboardCtrl', ['$scope', '$filter', 'matchUserFactory',
  ($scope, $filter, matchUserFactory) ->
    $scope.form = {}

    matchUserFactory.getMatchUsers()
      .then ((data) ->
        $scope.matchUsers = data.data.match_users
        $scope.teamUsers = [{ key: "Humans", y: $scope.activeMatch.humans },
                            { key: "Zombies", y: $scope.activeMatch.zombies }]
        return
      ), ((error) ->
        return
      )

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

    $scope.setPrinted = ->
      matchUserFactory.setPrinted()
        .success (data) ->
          Messenger().post 'Save successful'
          return
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
          return

    $scope.$watchGroup ['matchUsers', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.matchUsers, $scope.form.searchBox)
      return

    $scope.statusUsers = [{ key: "Ready", y: 843 },
                          { key: "Partial", y: 112 },
                          { key: "Inactive", y: 250 }
                          ]

    $scope.teamColors = ['#2A9FD6', '#CC0000']
    $scope.statusColors = ['#2A9FD6', '#FF8800', '#CC0000'] 

    $scope.xFunction = ->
      (d) -> d.key

    $scope.yFunction = ->
      (d) -> d.y

    $scope.colorTeamFunction = ->
      (d, i) -> $scope.teamColors[i]

    $scope.colorStatusFunction = ->
      (d, i) -> $scope.statusColors[i]

    return
  ])