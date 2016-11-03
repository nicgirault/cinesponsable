angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', (
  $scope
  $mdMedia
  $mdDialog
  $stateParams
  Showtime
  Movie
) ->
  Showtime.query
    filter:
      where:
        datetime:
          gt: new Date()
        theaterId: $stateParams.theaterId
      order: 'datetime ASC'
  .$promise.then (showtimes) ->
    movieIds = (showtime.movieId for showtime in showtimes)
    for showtime in showtimes
      showtime.datetimeString = moment(showtime.datetime)
        .format('dddd D MMMM [à] HH[h]mm')
    $scope.showtimesByMovie = _.groupBy showtimes, (showtime) -> showtime.movieId
    Movie.query
      filter:
        where:
          id:
            inq: _.uniq movieIds
    .$promise
  .then (movies) ->
    $scope.movies = movies
    $scope.ready = true
