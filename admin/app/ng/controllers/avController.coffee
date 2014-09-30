angular.module('wraith.controllers')

.controller('AvCtrl', ['$scope', '$filter', 'avFactory',
  ($scope, $filter, avFactory) ->
    $scope.form = {}

    avFactory.getAntiviri()
      .success (data) ->
        $scope.avs = data.antiviri
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

    $scope.$watchGroup ['avs', 'form.searchBox'], () ->
      $scope.currentPage = 0
      $scope.filteredData = $filter('filter')($scope.avs, $scope.form.searchBox)
      return

    $scope.addNewAvs = ->
      avFactory.addNewAvs($scope.form.addNum)
        .success (data) ->
          $scope.avs = $scope.avs.concat(data.antiviri)
          Messenger().post 'Creation successful'
        .error (error) ->
          Messenger().post 'Creation failed'

    return
  ])