angular.module 'Cinesponsable.theater'
.controller 'TheaterListCtrl', ($scope, $state, theaters) ->
  $scope.theaters = theaters

  $scope.showtime = (theater) ->
    $state.go 'base.showtime', {theaterId: theater.code}
