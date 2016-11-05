angular.module 'Cinesponsable.movie'
.controller 'MovieDetailsCtrl', (
  $scope
  $stateParams
  Movie
) ->
  $scope.ready = false

  Movie.get(movieId: $stateParams.movieId).$promise.then (movie) ->
    $scope.movie = movie
    $scope.ready = true
