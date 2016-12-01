angular.module 'Cinesponsable.search'
.service 'SearchClient', (algolia) ->
  client = algolia.Client("TSYR5UGKF1", '8400ab6f87158e758d7a4cdf43579591')

  theaterIndex: client.initIndex('indecine_theaters')
  movieIndex: client.initIndex('indecine_movies')
