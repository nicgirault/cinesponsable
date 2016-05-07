angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeListCtrl', ($scope, $stateParams, Showtime, Position) ->
  where = {}
  where.movieId = $stateParams.movieId if $stateParams.movieId?
  Position.get().then (position) ->
    Showtime.query(
      filter:
        include: ['movie', 'theater']
        where: where
        order: 'datetime ASC'
      position: "#{position.lat};#{position.lng}"
    ).$promise
  .then (showtimes) ->
      for showtime in showtimes
        if $stateParams.movieId?
          showtime.title = showtime.theater.name
          showtime.subtitle = "à #{showtime.theater.actualDistance.toFixed()} kms"
        else
          showtime.title = showtime.movie.originalTitle
        showtime.datetimeString = moment(showtime.datetime)
          .format('dddd D MMMM [à] HH[h]mm')
      $scope.showtimes = showtimes
