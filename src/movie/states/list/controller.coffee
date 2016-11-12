angular.module 'Cinesponsable.movie'
.controller 'MovielistCtrl', (
  $scope
  $timeout
  MovieRepository
  position
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
