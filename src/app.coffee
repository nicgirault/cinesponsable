'use strict'

angular.module 'Cinesponsable', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngMaterial'
  'ui.router'
  'app.templates'
  'Parse'
  'uiGmapgoogle-maps'

  'Cinesponsable.common'
  'Cinesponsable.theater'
  'Cinesponsable.alloCine'
  'Cinesponsable.showtime'
  'Cinesponsable.map'
]

.config (
  ParseProvider
) ->
  ParseProvider.initialize(
    "2Y3JhneedL6TfTswvBgPfJbZ0qxQRJHj8jg0GqEU", # Application ID
    "w1ek8EuSk7dD8bEBDSN5J8XTyXlGuOgx8mv7q7MD"  # REST API Key
  )

.config ($mdIconProvider) ->
  $mdIconProvider
    .defaultIconSet 'icons/mdi.light.svg'

.constant 'ALLOCINE_API_URL', 'http://api.allocine.fr/rest/v3'
.constant 'ALLOCINE_PARTNER_TOKEN', 'yW5kcm9pZC12M3M'

.config (
  $locationProvider
  $urlRouterProvider
) ->
  $locationProvider.hashPrefix '!'
  $urlRouterProvider.otherwise '/map'

.config (uiGmapGoogleMapApiProvider) ->
  uiGmapGoogleMapApiProvider.configure {
      #key: 'AIzaSyDXUwacxRBdrqDyJ0x7kqqD9DuvVxJjngI'
      v: '3.21'
      libraries: ''
    }
