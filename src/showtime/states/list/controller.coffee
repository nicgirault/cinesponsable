angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeListCtrl', ($scope, $stateParams, Showtime) ->
  where = {}
  where.movieId = $stateParams.movieId if $stateParams.movieId?

  Showtime.query(
    filter:
      include: ['movie', 'theater']
      where: where
      order: 'datetime ASC'
  ).$promise.then (showtimes) ->
    for showtime in showtimes
      if $stateParams.movieId?
        showtime.title = showtime.theater.name
      else
        showtime.title = showtime.movie.originalTitle
      showtime.datetimeString = moment(showtime.datetime)
        .format('dddd D MMMM [à] HH[h]mm')
    $scope.showtimes = showtimes
