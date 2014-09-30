angular.module('wraith.controllers')

.controller('TagCtrl', ['$scope', '$filter', 'tagFactory',
  ($scope, $filter, tagFactory) ->
    $scope.form = {}
    $scope.data = []

    tagFactory.getTags()
      .then ((data) ->
        $scope.tags = data.data.tags
        return
      ), ((error) ->
        return
      )

    $scope.$watchGroup ['tags', 'form.searchBox'], () ->
      $scope.filteredData = $filter('filter')($scope.tags, $scope.form.searchBox)
      return

    return
  ])