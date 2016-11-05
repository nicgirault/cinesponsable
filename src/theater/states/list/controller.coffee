angular.module 'Cinesponsable.theater'
.controller 'TheaterListCtrl', ($scope, $state, Theater) ->
  $scope.ready = false
  Theater.query().$promise.then (theaters) ->
    $scope.theaters = theaters
    $scope.ready = true

  $scope.showtime = (theater) ->
    $state.go 'base.showtimeByTheater', {theaterId: theater.id}
