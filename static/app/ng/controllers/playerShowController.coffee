angular.module('wraith.controllers')

.controller('PlayerShowCtrl', ['$scope', '$stateParams', 'userFactory',
  ($scope, $stateParams, userFactory) ->

    # Grab the mission data on load
    userFactory.getUser($stateParams.id)
      .success (data) ->
        $scope.user = data.user
      .error (error) ->
        return
  ])