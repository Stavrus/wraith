angular.module('wraith.controllers')

.controller('AvEditCtrl', ['$scope', '$stateParams', 'avFactory',
  ($scope, $stateParams, avFactory) ->

    avFactory.getAntivirus($stateParams.id)
      .success (data) ->
        $scope.av = data.antivirus
      .error (error) ->
        return

    $scope.save = ->
      avFactory.updateAntivirus($scope.av)
      return
  ])