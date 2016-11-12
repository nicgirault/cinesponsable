angular.module 'Cinesponsable', [
  'ng'
  'ngResource'
  'ngAnimate'
  'ngMaterial'
  'ui.router'
  'app.templates'
  'ui-leaflet'
  'infinite-scroll'
  'LocalStorageModule'

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

.run ->
  # http://stackoverflow.com/questions/10022156/underscore-js-groupby-multiple-values
  _.groupByMulti = (obj, values, context) ->
    if !values.length
      return obj
    byFirst = _.groupBy(obj, values[0], context)
    rest = values.slice(1)
    for prop of byFirst
      byFirst[prop] = _.groupByMulti(byFirst[prop], rest, context)
    byFirst
