angular.module('wraith.controllers')

.controller('UserEditCtrl', ['$scope', '$stateParams', 'userFactory', 'matchUserFactory'
  ($scope, $stateParams, userFactory, matchUserFactory) ->
    # Defaults
    $scope.cameraCaptured = false
    $scope.displayCurrentImage = true
    $scope.cameraControl = {}
    $scope.cameraControl.enabled = false
    $scope.cameraControl.frozen = false

    # Grab the user data on load
    userFactory.getUser($stateParams.id)
      .success (data) ->
        $scope.user = data.user
        return
      .error (error) ->
        return

    # Grab the active match profile
    matchUserFactory.getActiveMatchUserByUser($stateParams.id)
      .then ((data) ->
          if data.data.match_users
            $scope.matchUser = data.data.match_users[0]
          return
        ), ((error) ->
          return
        )

    $scope.saveUser = ->
      userFactory.updateUser($scope.user)
        .success (data) ->
          Messenger().post 'Save successful'
        .error (error) ->
          Messenger().post 'Save failed'
      return

    $scope.saveMatchUser = ->
      matchUserFactory.updateMatchUser($scope.matchUser)
        .success (data) ->
          Messenger().post 'Save successful'
        .error (error) ->
          Messenger().post 'Save failed'
      return

    $scope.uploadCameraCapture = ->
      if $scope.user
        $scope.user.avatar_upload = $scope.cameraControl.image
        userFactory.updateUser($scope.user)
      else
        Messenger().post 'No user model available to update!'
      return

    return
  ])