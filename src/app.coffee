'use strict'

angular.module 'Cinesponsable', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngMaterial'
  'ui.router'
  'app.templates'
  'leaflet-directive'

  'Cinesponsable.common'
  'Cinesponsable.theater'
  'Cinesponsable.showtime'
  'Cinesponsable.movie'
  'Cinesponsable.map'
  'Cinesponsable.search'
  'Cinesponsable.constants'
]

.config ($mdGestureProvider) ->
  $mdGestureProvider.skipClickHijack()

.config ($mdIconProvider) ->
  $mdIconProvider
  .defaultIconSet 'icons/mdi.light.svg'

.config (
  $locationProvider
  $urlRouterProvider
) ->
  $locationProvider.hashPrefix '!'
  $urlRouterProvider.otherwise '/map'
