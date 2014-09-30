angular.module('wraith.controllers')

# MatchFactory is included as it pulls in the active match
.controller('AppCtrl', ['$scope', '$rootScope', '$http', 'matchFactory',
  ($scope, $rootScope, $http, matchFactory) ->

    $scope.zombies = [{name: 'John Quincy Adams', tags_count: 27},
                    {name: 'Rutherford B. Hayes', tags_count: 22},
                    {name: 'William Henry Harrison', tags_count: 19},
                    {name: 'Theodore Roosevelt', tags_count: 14},
                    {name: 'Dwight D. Eisenhower', tags_count: 3}
                  ]

    $scope.tags = [{zombie: 'John Quincy Adams', human: 'Abraham Lincoln'},
                    {zombie: 'John Quincy Adams', human: 'Millard Fillmore'},
                    {zombie: 'John Quincy Adams', human: 'Wiliam Howard Taft'},
                    {zombie: 'William Henry Harrison', human: 'Richard Nixon'},
                    {zombie: 'Dwight D. Eisenhower', human: 'Grover Cleveland'}
                  ]

    return
  ])