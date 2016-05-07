angular.module 'Cinesponsable.movie'
.controller 'MovieDetailsCtrl', (
  $scope
  $stateParams
  Movie
) ->
  console.log 'in details'
  Movie.get(movieId: $stateParams.movieId).$promise.then (movie) ->
    $scope.movie = movie
