angular.module('wraith.controllers')

.controller('IndexCtrl', ['$scope', '$interval', 'matchFactory', 'dateFactory', 'tagFactory', 'matchUserFactory'
  ($scope, $interval, matchFactory, dateFactory, tagFactory, matchUserFactory) ->
    $scope.started = false

    $scope.max_days = 30
    $scope.max_hours = 24
    $scope.max_minutes = 60
    $scope.max_seconds = 60

    $scope.knobOptions =
      width: 160
      displayInput: true
      fgColor: '#2A9FD6'
      thickness: 0.1

    $scope.knobOptionsActive =
      width: 100
      displayInput: true
      fgColor: '#2A9FD6'
      thickness: 0.07

    matchUserFactory.getMatchUsers()
      .then ((data) ->
        $scope.matchUsers = data.data.match_users

        # Generate random values for the histogram
        arr = []
        i = 0
        numElems = 120
        numMax = 40
        chart = '#kill-histogram'
        while i < numElems
          arr.push Math.round(Math.random() * numMax)
          i++

        # Set up the scales
        x = d3.scale.linear().domain([0, numElems]).range([0, $(chart).width()])
        y = d3.scale.linear().domain([0, numMax]).rangeRound([0, $(chart).height()])

        # Background column (so that title is always displayed)
        d3.select(chart)
          .append('svg')
          .selectAll('g')
          .data(arr).enter()
          .append('g')
          .append('rect')
          .attr('class', 'fill')
          .attr('x', (d,i) -> x(i) )
          .attr('y', 0)
          .attr('width', $(chart).width() / numElems)
          .attr('height', $(chart).height())
          .append('title').text((d) -> d)

        d3.select(chart)
          .selectAll('g')
          .append('rect')
          .attr('class', 'bar')
          .attr('x', (d,i) -> x(i) )
          .attr('y', $(chart).height())
          .attr('width', $(chart).width() / numElems)
          .attr('height', 0)
          .append('title').text((d) -> d)

        d3.select(chart)
          .selectAll('.bar')
          .transition()
          .duration(1400)
          .attr('y', (d) -> $(chart).height() - y(d))
          .attr('height', (d) -> y(d))
        return
      ), ((error) ->
        return
      )

    tagFactory.getTags()
      .then ((data) ->
         # Orderby isn't returning properly sorted arrays, have to sort manually
        $scope.tags = data.data.tags.sort (a,b) ->
          new Date(a.created_at) > new Date(b.created_at) ? -1 : 1
        return
      ), ((error) ->
        return
      )

    $scope.$watch 'activeMatch', () ->
      start = new Date($scope.activeMatch.date_start)
      end = new Date($scope.activeMatch.date_end)
      now = new Date()
      if now > start
        $scope._countdown = end
        $scope.started = true
      else
        $scope._countdown = start
        $scope.started = false

      if $scope.activeMatch.date_start
        $scope.matchStarted = $scope._countdown < now
        $scope.countdown = dateFactory.getTimeBetween(now, $scope._countdown)
      return

    updateCountdown = ->
      if $scope.countdown
        $scope.countdown = dateFactory.getTimeBetween(new Date(), $scope._countdown)

    countdownUpdater = $interval(updateCountdown, 1000)

    $scope.$on '$destroy', ->
      $interval.cancel countdownUpdater

    return
  ])