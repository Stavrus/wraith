angular.module('wraith.controllers')

.controller('ClanEditCtrl', ['$scope', '$stateParams', 'clanFactory',
  ($scope, $stateParams, clanFactory) ->
    $scope.currentPage = 0
    $scope.pageSize = 0

    clanFactory.getClan($stateParams.id)
      .success (data) ->
        $scope.clan = data.clan
        $scope.getUsers()
      .error (error) ->
        return

    $scope.getUsers = ->
      clanFactory.getClanUsers($stateParams.id)
        .success (data) ->
          $scope.pageSize = data.users.length
          $scope.clanUsers = data.users
          $scope.$apply()
        .error (error) ->
          return

    $scope.save = ->
      clanFactory.updateClan($scope.clan)
        .success (data) ->
          Messenger().post 'Save successful'
        .error (error) ->
          Messenger().post 'Save failed'
      return

    return
  ])