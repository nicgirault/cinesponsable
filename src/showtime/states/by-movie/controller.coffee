angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeByMovieCtrl', ($scope, $stateParams, Showtime, Position) ->

  Position.get().then (position) ->
    Showtime.query(
      filter:
        include: ['movie', 'theater']
        where:
          movieId: $stateParams.movieId
        order: 'datetime ASC'
      position: "#{position.lat};#{position.lng}"
    ).$promise
  .then (showtimes) ->
    groupByDay = (showtime) ->
      moment(showtime.datetime).format('DD-MM-YY')
    $scope.groupedShowtimes = _.groupByMulti showtimes, ['theaterId', 'language', groupByDay]

    $scope.ready = true
