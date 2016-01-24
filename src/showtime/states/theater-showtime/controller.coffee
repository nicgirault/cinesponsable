angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', ($scope, theater, showtimes) ->
  $scope.showtimes = showtimes
  $scope.theater = theater
  $scope.versionLabel =
    true: "original"
    false: "doublage"
