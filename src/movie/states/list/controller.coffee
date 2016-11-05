angular.module 'Cinesponsable.movie'
.controller 'MovielistCtrl', (
  $scope
  Movie
  position
) ->
  $scope.ready = false

  Movie.onTheBill().$promise.then (movies) ->
    $scope.movies = movies
    $scope.ready = true
