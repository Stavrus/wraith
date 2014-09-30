angular.module('wraith.controllers')

.controller('AvNewCtrl', ['$scope', '$http',
  ($scope, $http) ->
    $scope.form = {}

    $scope.save = ->
      obj = {code: $scope.form.av, match: $scope.activeMatch.id}
      $http.post('/api/v1/antiviri/use', obj)
        .success (data) ->
          Messenger().post 'Save successful'
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
      return
  ])