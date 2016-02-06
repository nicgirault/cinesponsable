'use strict'

angular.module 'Cinesponsable', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngMaterial'
  'ui.router'
  'app.templates'
  'Parse'
  'leaflet-directive'

  'Cinesponsable.common'
  'Cinesponsable.theater'
  'Cinesponsable.alloCine'
  'Cinesponsable.showtime'
  'Cinesponsable.map'
  'Cinesponsable.search'
]

.config (
  ParseProvider
) ->
  ParseProvider.initialize(
    "2Y3JhneedL6TfTswvBgPfJbZ0qxQRJHj8jg0GqEU", # Application ID
    "w1ek8EuSk7dD8bEBDSN5J8XTyXlGuOgx8mv7q7MD"  # REST API Key
  )

.constant 'ALLOCINE_API_URL', 'http://api.allocine.fr/rest/v3'
.constant 'ALLOCINE_PARTNER_TOKEN', 'yW5kcm9pZC12M3M'

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
