angular.module 'Cinesponsable.theater'
.service 'Theater', ($resource, API_URL) ->

  $resource(
    "#{API_URL}/api/Theaters/:theaterId:action",
    theaterId: '@id',
  )
