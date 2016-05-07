angular.module 'Cinesponsable.theater'
.service 'Theater', ($resource, API_URL) ->

  $resource(
    "#{API_URL}/api/Theaters/:theaterId:action/:actionPerTheater",
    {theaterId: '@id'},
    getOnTheBillMovies:
      method: 'GET'
      params:
        actionPerTheater: 'on-the-bill'
      isArray: true
  )
