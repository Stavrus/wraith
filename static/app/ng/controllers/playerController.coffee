angular.module('wraith.controllers')

.controller('PlayerCtrl', ['$scope', '$filter', '$state', 'matchUserFactory',
  ($scope, $filter, $state, matchUserFactory) ->
    $scope.form = {}
    $scope.data = []

    matchUserFactory.getMatchUsers()
      .then ((data) ->
        $scope.players = data.data.match_users
        return
      ), ((error) ->
        return
      )

    $scope.$watchGroup ['players', 'form.searchBox'], () ->
      $scope.filteredData = $filter('filter')($scope.players, $scope.form.searchBox)
      return

    # $scope.showPlayer = (id) ->
    #   $state.go('players.show', {id: id})

    return
  ])