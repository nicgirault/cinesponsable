angular.module 'Cinesponsable.theater'
.controller 'TheaterListCtrl', ($scope, $state, Theater) ->
  Theater.query().$promise.then (theaters) ->
    $scope.theaters = theaters

  $scope.showtime = (theater) ->
    console.log theater
    $state.go 'base.showtimeByTheater', {theaterId: theater.id}
