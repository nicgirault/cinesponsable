angular.module 'Cinesponsable.movie'
.controller 'MovielistCtrl', (
  $scope
  Movie
  position
) ->
  Movie.onTheBill().$promise.then (movies) ->
    $scope.movies = movies
    
