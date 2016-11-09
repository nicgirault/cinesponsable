angular.module 'Cinesponsable.movie'
.controller 'MovielistCtrl', (
  $scope
  MovieService
  position
) ->
  $scope.ready = false

  MovieService.onTheBill().then (movies) ->
    for movie in movies
      if movie.poster?
        url = movie.poster.split('/')
        url.splice(3, 0, 'cx_240_320')
    $scope.movies = movies
    $scope.ready = true
