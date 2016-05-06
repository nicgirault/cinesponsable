angular.module 'Cinesponsable.theater'
.service 'Movie', ($resource, API_URL) ->

  $resource(
    "#{API_URL}/api/Movies/:movieId:action",
    {movieId: '@id'},
    onTheBill:
      method: 'GET'
      params:
        action: 'on-the-bill'
      isArray: true
  )
