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
  'nvd3ChartDirectives'
  'wraith.controllers'
  'wraith.directives'
  'wraith.filters'
  'wraith.services'
  'templates'
])
.config ($stateProvider, $urlRouterProvider, $locationProvider, $authProvider) ->

  $locationProvider.html5Mode true
  $urlRouterProvider.otherwise '/admin'

  $authProvider.configure
    apiUrl: '/api/v1'
      
  $stateProvider

    .state 'dashboard',
      url: '/admin'
      abstract: true
      templateUrl: '/app/dashboard/index.html'
      controller: 'DashboardCtrl'

    .state 'dashboard.overview',
      url: ''
      templateUrl: '/app/dashboard/_overview.html'

    .state 'dashboard.ozs',
      url: '/ozs'
      templateUrl: '/app/dashboard/_ozs.html'

    .state 'dashboard.preview',
      url: '/preview'
      templateUrl: '/app/dashboard/_preview.html'

    .state 'dashboard.print',
      url: '/print'
      templateUrl: '/app/dashboard/_print.html'

    .state 'avs',
      url: '/admin/avs'
      abstract: true
      template: '<ui-view/>'

    .state 'avs.list',
      url: ''
      templateUrl: '/app/avs/index.html'
      controller: 'AvCtrl'

    .state 'avs.edit',
      url: '/:id'
      templateUrl: '/app/avs/edit.html'
      controller: 'AvEditCtrl'

    .state 'badges',
      url: '/admin/badges'
      abstract: true
      template: '<ui-view/>'

    .state 'badges.list',
      url: ''
      templateUrl: '/app/badges/index.html'
      controller: 'BadgeCtrl'

    .state 'badges.edit',
      url: '/:id'
      templateUrl: '/app/badges/edit.html'
      controller: 'BadgeEditCtrl'

    .state 'clans',
      url: '/admin/clans'
      abstract: true
      template: '<ui-view/>'

    .state 'clans.list',
      url: ''
      templateUrl: '/app/clans/index.html'
      controller: 'ClanCtrl'

    .state 'clans.edit',
      url: '/:id'
      abstract: true
      templateUrl: '/app/clans/edit.html'
      controller: 'ClanEditCtrl'

    .state 'clans.edit.overview',
      url: ''
      templateUrl: '/app/clans/_overview.html'

    .state 'clans.edit.picture',
      url: '/picture'
      templateUrl: '/app/clans/_picture.html'

    .state 'matches',
      url: '/admin/matches'
      abstract: true
      template: '<ui-view/>'

    .state 'matches.list',
      url: ''
      templateUrl: '/app/matches/index.html'
      controller: 'MatchCtrl'

    .state 'matches.edit',
      url: '/:id'
      templateUrl: '/app/matches/edit.html'
      controller: 'MatchEditCtrl'

    .state 'matches.new',
      url: '/new'
      templateUrl: '/app/matches/new.html'
      controller: 'MatchNewCtrl'

    .state 'missions',
      url: '/admin/missions'
      abstract: true
      template: '<ui-view/>'

    .state 'missions.list',
      url: ''
      templateUrl: '/app/missions/index.html'
      controller: 'MissionCtrl'

    .state 'missions.new',
      url: '/new'
      templateUrl: '/app/missions/new.html'
      controller: 'MissionNewCtrl'

    .state 'missions.edit',
      url: '/:id'
      templateUrl: '/app/missions/edit.html'
      controller: 'MissionEditCtrl'

    .state 'tags',
      url: '/admin/tags'
      abstract: true
      template: '<ui-view/>'

    .state 'tags.list',
      url: ''
      templateUrl: '/app/tags/index.html'
      controller: 'TagCtrl'

    .state 'tags.edit',
      url: '/:id'
      templateUrl: '/app/tags/edit.html'
      controller: 'TagEditCtrl'

    .state 'teams',
      url: '/admin/teams'
      abstract: true
      template: '<ui-view/>'

    .state 'teams.list',
      url: ''
      templateUrl: '/app/teams/index.html'
      controller: 'TeamCtrl'

    .state 'teams.edit',
      url: '/:id'
      templateUrl: '/app/teams/edit.html'
      controller: 'TeamEditCtrl'

    .state 'tiers',
      url: '/admin/tiers'
      abstract: true
      template: '<ui-view/>'

    .state 'tiers.list',
      url: ''
      templateUrl: '/app/tiers/index.html'
      controller: 'TierCtrl'

    .state 'tiers.new',
      url: '/new'
      templateUrl: '/app/tiers/new.html'
      controller: 'TierNewCtrl'

    .state 'tiers.edit',
      url: '/:id'
      abstract: true
      templateUrl: '/app/tiers/edit.html'
      controller: 'TierEditCtrl'

    .state 'tiers.edit.overview',
      url: ''
      templateUrl: '/app/tiers/_overview.html'

    .state 'tiers.edit.results',
      url: '/results'
      templateUrl: '/app/tiers/_results.html'

    .state 'users',
      url: '/admin/users'
      abstract: true
      template: '<ui-view/>'

    .state 'users.list',
      url: ''
      templateUrl: '/app/users/index.html'
      controller: 'UserCtrl'

    .state 'users.edit',
      url: '/:id'
      abstract: true
      templateUrl: '/app/users/edit.html'
      controller: 'UserEditCtrl as edit'

    .state 'users.edit.overview',
      url: ''
      templateUrl: '/app/users/_overview.html'

    .state 'users.edit.picture',
      url: '/picture'
      templateUrl: '/app/users/_picture.html'

    .state 'users.edit.activity',
      url: '/activity'
      templateUrl: '/app/users/_activity.html'

# Startup scripts
$ ->
  Holder.run()

  # https://github.com/zurb/foundation/issues/3800
  # Off-canvas mobile menu won't extend its height past the height of the current
  # page without this workaround. Test with a short page on a laptop rendering mobile.
  timer = undefined
  $(window).resize(->
    clearTimeout timer
    timer = setTimeout(->
      $(".inner-wrap").css "min-height", $(window).height() + "px"
      return
    , 40)
    return
  ).resize()

  # https://productforums.google.com/forum/#!msg/chrome/tYHSqc-fqso/g-KISvfeYukJ
  # Font Awesome icons won't show up until page resize without this workaround.
  $("body").hide().show()