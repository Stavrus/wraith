angular.module('wraith.services')

.factory('dateFactory', [
  () ->

    dataFactory = {}

    # Gets time needed to go from date1 to date2
    dataFactory.getTimeBetween = (date1, date2) ->
      diff = date2.getTime() - date1.getTime()
      obj = {}

      if diff > 0
        days  = Math.floor(diff / (1000*60*60*24))
        hours = Math.floor(diff / (1000*60*60))
        mins  = Math.floor(diff / (1000*60))
        secs  = Math.floor(diff / 1000)

        obj.days  = days
        obj.hours = hours - days  * 24
        obj.mins  = mins  - hours * 60
        obj.secs  = secs  - mins  * 60

        return obj
      else
        return {days: 0, hours: 0, mins: 0, secs: 0}

    return dataFactory
  ])