angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', (
  $scope
  $mdMedia
  $mdDialog
  $stateParams
  Showtime
  Movie
) ->
  console.log moment().add(1, 'days').toDate()
  Showtime.query
    filter:
      where:
        and: [
          datetime:
            gt: new Date()
        ,
          datetime:
            lt: moment().add(7, 'days').toDate()
        ]
        theaterId: $stateParams.theaterId
      order: 'datetime ASC'
  .$promise.then (showtimes) ->
    movieIds = (showtime.movieId for showtime in showtimes)
    for showtime in showtimes
      showtime.day = moment(showtime.datetime)
        .format('dddd D MMMM')

    groupByDay = (showtime) ->
      moment(showtime.datetime).format('DD-MM-YY')
    groupedShowtimes = _.groupByMulti showtimes, ['movieId', 'language', groupByDay]
    console.log groupedShowtimes
    $scope.groupedShowtimes = groupedShowtimes
    Movie.query
      filter:
        where:
          id:
            inq: _.uniq movieIds
    .$promise
  .then (movies) ->
    $scope.movies = movies
    $scope.ready = true
