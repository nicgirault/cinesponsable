angular.module 'Cinesponsable.theater'
.controller 'TheaterListCtrl', ($scope, $state, Theater, Position) ->
  $scope.ready = false
  Position.get().then (position) ->
    Theater.query
      filter:
        where:
          geopoint:
            near: [position.lat, position.lng]
        limit: 20
    .$promise
  .then (theaters) ->
    $scope.theaters = theaters
    $scope.ready = true

  $scope.showtime = (theater) ->
    $state.go 'base.showtimeByTheater', {theaterId: theater.id}
