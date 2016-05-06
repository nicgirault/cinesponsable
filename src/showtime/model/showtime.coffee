angular.module 'Cinesponsable.theater'
.service 'Showtime', ($resource, API_URL) ->

  $resource(
    "#{API_URL}/api/Showtimes/:showtimeId:action",
    {showtimeId: '@id'},
  )
