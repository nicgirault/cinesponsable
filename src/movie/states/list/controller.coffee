angular.module 'Cinesponsable.movie'
.controller 'MovielistCtrl', (
  $scope
  $timeout
  $state
  MovieRepository
  position
  SearchClient
) ->
  $scope.ready = false
  $scope.movies = []

  page = 0
  allIsLoaded = false

  loadingPromise = MovieRepository.onTheBill(page)
  .then (movies) ->
    loadingPromise = null
    page++
    $scope.movies = $scope.movies.concat movies
    $scope.ready = true

  $scope.loadMore = ->
    return if allIsLoaded or loadingPromise?
    loadingPromise = MovieRepository.onTheBill(page)
    .then (movies) ->
      $timeout ->
        loadingPromise = null
      , 300 # let the time to render to list
      return allIsLoaded = true if movies.length is 0
      page++
      $scope.movies = $scope.movies.concat movies

  $scope.goToMovieDetails = (movieId) ->
    $state.go 'base.showtimeByMovie', {movieId: movieId}

  $scope.search =
    query: ''
    movies: []

  $scope.$watch 'search.query', ->
    if $scope.search.query is ''
      $scope.search.movies = []
      return

    SearchClient.movieIndex.search($scope.search.query)
    .then (content) ->
      for movie in content.hits
        movie.releaseDate = moment(movie.releaseDate).format('D MMMM YYYY')
      $scope.search.movies = content.hits
    .catch console.error
