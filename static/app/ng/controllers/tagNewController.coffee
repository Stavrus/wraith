angular.module('wraith.controllers')

.controller('TagNewCtrl', ['$scope', '$http',
  ($scope, $http) ->
    $scope.form = {}

    $scope.save = ->
      obj = {tag: {source: $scope.form.source, target: $scope.form.target}}
      $http.post('/api/v1/tags?match=' + $scope.activeMatch.id, obj)
        .success (data) ->
          Messenger().post 'Save successful'
        .error (errors) ->
          Messenger().post(errors.error) if errors.error # Single Error
          if errors.errors                               # Multiple Errors
            for error in errors.errors
              Messenger().post error
      return
  ])