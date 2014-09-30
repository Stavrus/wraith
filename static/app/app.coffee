'use strict'

Messenger.options =
  extraClasses: 'messenger-fixed messenger-on-bottom messenger-on-right'
  theme: 'flat'

# Declare app level module which depends on filters, and services
angular.module('wraith', [
  'wraith-auth'
  'ui.router'
  'angularMoment'
  'ngQuickDate'
  'tableSort'
  'btford.markdown'
  'ui.knob'
  'wraith.controllers'
  'wraith.directives'
  'wraith.filters'
  'wraith.services'
  'templates'
])
.config ($stateProvider, $urlRouterProvider, $locationProvider, $authProvider) ->

  $locationProvider.html5Mode true
  $urlRouterProvider.otherwise '/'

  $authProvider.configure
    apiUrl: '/api/v1'
      
  $stateProvider

    .state 'index',
      url: '/'
      templateUrl: '/app/index.html'
      controller: 'IndexCtrl'

    .state 'avs',
      url: '/antivirus'
      templateUrl: '/app/avs/new.html'
      controller: 'AvNewCtrl'

    .state 'badges',
      url: '/badges'
      abstract: true
      template: '<ui-view/>'

    .state 'badges.list',
      url: ''
      templateUrl: '/app/badges/index.html'
      controller: 'BadgeCtrl'

    .state 'clans',
      url: '/clans'
      abstract: true
      template: '<ui-view/>'

    .state 'clans.list',
      url: ''
      templateUrl: '/app/clans/index.html'
      controller: 'ClanCtrl'

    .state 'missions',
      url: '/missions'
      abstract: true
      template: '<ui-view/>'

    .state 'missions.list',
      url: ''
      templateUrl: '/app/missions/index.html'
      controller: 'MissionCtrl'

    .state 'players',
      url: '/players'
      abstract: true
      template: '<ui-view/>'

    .state 'players.list',
      url: ''
      templateUrl: '/app/players/index.html'
      controller: 'PlayerCtrl'

    .state 'players.show',
      url: '/:id'
      templateUrl: '/app/players/show.html'
      controller: 'PlayerShowCtrl'

    .state 'profile',
      url: '/profile'
      abstract: true
      templateUrl: '/app/profile/index.html'
      controller: 'ProfileCtrl'

    .state 'profile.home',
      url: ''
      templateUrl: '/app/profile/_home.html'

    .state 'profile.clan',
      url: '/clan'
      templateUrl: '/app/profile/_clan.html'

    .state 'profile.invites',
      url: '/invites'
      templateUrl: '/app/profile/_invites.html'

    .state 'rules',
      url: '/rules'
      templateUrl: '/app/rules.html'

    .state 'tags',
      url: '/tags'
      abstract: true
      template: '<ui-view/>'

    .state 'tags.list',
      url: ''
      templateUrl: '/app/tags/index.html'
      controller: 'TagCtrl'

    .state 'tags.new',
      url: '/new'
      templateUrl: '/app/tags/new.html'
      controller: 'TagNewCtrl'

    .state 'tiers',
      url: '/tiers'
      abstract: true
      template: '<ui-view/>'

    .state 'tiers.list',
      url: ''
      templateUrl: '/app/tiers/index.html'
      controller: 'TierCtrl'

# Startup scripts
$ ->
  Holder.run()

  # https://productforums.google.com/forum/#!msg/chrome/tYHSqc-fqso/g-KISvfeYukJ
  # Font Awesome icons won't show up until page resize without this workaround.
  $('body').hide().show()

  $.ajax
    url: 'https://hvz.rit.edu/tags'
    type: "get"
    dataType: ""
    crossDomain: true
    success: (data) ->
      debugger
    error: (status) ->