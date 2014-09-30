angular.module('wraith.directives')

.directive 'cameraCapture', ($rootScope) ->
  restrict: 'E'
  scope:
    width: '@'
    height: '@'
    control: '='
  template: '<div ng-show="control.enabled">
              <video id="wr-camera-video" ng-hide="control.frozen" autoplay height="{{height}}" width="{{width}}" />
              <canvas id="wr-camera-canvas" ng-show="control.frozen" height="{{height}}" width="{{width}}" />
             </div>
             <div ng-hide="control.enabled">
              <img height="{{height}}" width="{{width}}" class="img-thumbnail" />
             </div>
             '

  link: (scope, element, attrs) ->

    scope.internalControl = scope.control || {}
    video = document.getElementById 'wr-camera-video'
    canvas = document.getElementById 'wr-camera-canvas'

    # Do not set up a watcher for scope.on($destroy) that stops the stream.
    # Destroying the stream results in permission denied errors on new streams.
    # Stream is kept active in window.stream (aka @stream).
    scope.$on '$destroy', ->
      scope.internalControl.enabled = false
      delete video.src if !!video
      return

    # Alias the first usable usermedia function in the user's browser
    navigator.getMedia = navigator.getUserMedia \
                        || navigator.webkitGetUserMedia \
                        || navigator.mozGetUserMedia \
                        || navigator.msGetUserMedia

    onStreamSuccess = (data) ->
      @stream = data
      scope.internalControl.enabled = true
      scope.internalControl.frozen = false
      url = window.URL || window.webkitURL
      video.src = url.createObjectURL(data)
      scope.$apply()
      return

    onStreamFail = (error) ->
      scope.enabled = false
      Messenger().post 'Error initializing camera.'
      return

    # Use the stream if it already exists, otherwise ask the browser for a new stream.
    if @stream
      onStreamSuccess(@stream)
    else
      navigator.getMedia {video: true}, onStreamSuccess, onStreamFail

    # External API calls
    scope.internalControl.takePicture = ->
      scope.internalControl.frozen = true
      context = canvas.getContext '2d'
      context.drawImage video, 0, 0, parseInt(scope.width), parseInt(scope.height)
      scope.internalControl.image = canvas.toDataURL 'image/png;base64', 1.0
      return

    return