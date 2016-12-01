angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', (
  $scope
  $stateParams
  $q
  $window
  Showtime
  Movie
  Theater
) ->
  $scope.openMenu = ($mdOpenMenu, ev) ->
    $mdOpenMenu(ev)

  $scope.setByDate = ->
    $scope.byDate = true
    $scope.byMovie = false
    return

  $scope.setByMovie = ->
    $scope.byDate = false
    $scope.byMovie = true
    return

  $scope.byMovie = true
  $scope.ready = false
  moviesPromise = Showtime.query
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
    if showtimes.length is 0
      $scope.noShowtime = true
    movieIds = (showtime.movieId for showtime in showtimes)
    for showtime in showtimes
      showtime.day = moment(showtime.datetime)
        .format('dddd D MMMM')

    groupByDay = (showtime) ->
      moment(showtime.datetime).format('DD-MM-YY')
    groupedShowtimes = _.groupByMulti showtimes, ['movieId', 'language', groupByDay]
    $scope.groupedShowtimes = groupedShowtimes
    Movie.query
      filter:
        where:
          id:
            inq: _.uniq movieIds
    .$promise
  .then (movies) ->
    $scope.movies = movies

  theaterPromise = Theater.get(theaterId: $stateParams.theaterId).$promise
  .then (theater) ->
    $scope.theater = theater

  $q.all [moviesPromise, theaterPromise]
  .then ->
    $scope.ready = true

  $scope.back = ->
    $window.history.back()
