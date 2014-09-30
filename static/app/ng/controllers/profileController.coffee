angular.module('wraith.controllers')

.controller('ProfileCtrl', ['$scope', '$rootScope', '$filter', 'matchUserFactory', 'userFactory', 'clanFactory', 'clanInviteFactory',
  ($scope, $rootScope, $filter, matchUserFactory, userFactory, clanFactory, clanInviteFactory) ->
    $scope.form = {ozInterest: false}

    $scope.getMatchUsers = ->
      matchUserFactory.getMatchUsers()
        .then ((data) ->
          $scope.matchUsers = data.data.match_users.filter (e) ->
                                if $scope.matchUser
                                  return e.clan_id != $scope.matchUser.clan_id
          return
        ), ((error) ->
          return
        )

    $scope.getMatchUser = ->
      matchUserFactory.getActiveMatchUserByUser()
        .then ((data) ->
          if data.data.match_users.length == 1
            $scope.matchUser = data.data.match_users[0]
          return
        ), ((error) ->
          return
        )

    $scope.getClanInvites = ->
      clanInviteFactory.getClanInvites()
        .success (data) ->
          $scope.clanInvites = data.clan_invites.filter (e) ->
                                  if $scope.matchUser
                                    return (e.sender != $scope.matchUser.name && e.clan_id != $scope.matchUser.clan_id)
                                  return false
          $scope.sentInvites = data.clan_invites
          return
        .error (error) ->
          return

    $scope.getClanMembers = (id) ->
      clanFactory.getClan(id)
        .success (data) ->
          $scope.clan = data.clan
          return
        .error (error) ->
          return
    
    $scope.getMatchUser().then ->
      $scope.getMatchUsers()
      $scope.getClanInvites()
      $scope.getClanMembers($scope.matchUser.clan_id) if $scope.matchUser && $scope.matchUser.clan

    $scope.$watchGroup ['clan', 'form.searchClanUsers'], () ->
      if $scope.clan
        $scope.filteredClanUsers = $filter('filter')($scope.clan.users, $scope.form.searchClanUsers)
      return

    $scope.$watchGroup ['clanInvites', 'form.searchClanInvites'], () ->
      $scope.filteredInvites = $filter('filter')($scope.clanInvites, $scope.form.searchClanInvites)
      return

    $scope.$watchGroup ['clanInvites', 'form.searchSentInvites'], () ->
      $scope.filteredSentInvites = $filter('filter')($scope.sentInvites, $scope.form.searchSentInvites)
      return

    $scope.$watchGroup ['matchUsers', 'form.searchInvitables'], () ->
      $scope.filteredInvitables = $filter('filter')($scope.matchUsers, $scope.form.searchInvitables)
      return

    $scope.register = ->
      userFactory.registerForMatch($scope.form.ozInterest)
        .then ((data) ->
          $scope.matchUser = data.data.match_user
          return
        ), ((error) ->
          return
        )

    $scope.createClan = ->
      clanFactory.createClan($scope.form.createClanName)
        .success (data) ->
          $rootScope.user = data.user
          return
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
          return

    $scope.leaveClan = ->
      clanFactory.leaveClan($scope.user.clan_id)
        .success (data) ->
          $rootScope.user = data.user
          return
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
          return

    $scope.acceptInvite = (id) ->
      clanInviteFactory.acceptInvite(id)
        .success (data) ->
          document.location.reload()
          return
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
          return


    $scope.invitePlayer = (id) ->
      clanFactory.invitePlayer(id)
        .success (data) ->
          Messenger().post 'Invite sent.'
          $scope.matchUsers = $scope.matchUsers.filter (e) ->
                                return e.id != id
          $scope.$apply()
          return
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
          return

    $scope.kickPlayer = (id) ->
      clanFactory.kickPlayer(id)
        .success (data) ->
          document.location.reload()
          return
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
          return

    return
  ])