angular.module('wraith.filters')

.filter 'paginate', () ->
  (input, start) ->
    if input
      start = +start
      input.slice(start)
