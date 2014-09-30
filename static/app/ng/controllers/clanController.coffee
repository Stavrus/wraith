angular.module('wraith.controllers')

.controller('ClanCtrl', ['$scope', '$filter', '$state', 'clanFactory',
  ($scope, $filter, $state, clanFactory) ->
    $scope.form = {}
    $scope.data = []

    clanFactory.getClans()
      .then ((data) ->
        $scope.clans = data.data.clans
        return
      ), ((error) ->
        return
      )

    $scope.$watchGroup ['clans', 'form.searchBox'], () ->
      $scope.filteredData = $filter('filter')($scope.clans, $scope.form.searchBox)
      return

    return
  ])