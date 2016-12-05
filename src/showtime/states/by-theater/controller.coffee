angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', (
  $scope
  $stateParams
  $q
  $window
  ShowtimeRepository
  Movie
  Theater
) ->
  $scope.openMenu = ($mdOpenMenu, ev) ->
    $mdOpenMenu(ev)

  $scope.setByDate = ->
    $scope.byDate = true
    $scope.byMovie = false

    ShowtimeRepository.getByDate($stateParams.theaterId)
    .then (byDateShowtimes) ->
      $scope.ready = true
      $scope.byDateShowtimes = byDateShowtimes

  $scope.dateTitle = (yyyymmdd) ->
    moment(yyyymmdd, 'DD-MM-YY').format('dddd')

  $scope.dateSubtitle = (yyyymmdd) ->
    moment(yyyymmdd, 'DD-MM-YY').format('D MMMM')

  $scope.setByMovie = ->
    $scope.byDate = false
    $scope.byMovie = true
    return

  $scope.byMovie = true
  $scope.ready = false
  moviesPromise = ShowtimeRepository.getByMovie($stateParams.theaterId)
  .then (groupedShowtimes) ->
    $scope.groupedShowtimes = groupedShowtimes
    Movie.query
      filter:
        where:
          id:
            inq: _.keys(groupedShowtimes)
    .$promise
  .then (movies) ->
    $scope.movies = movies
    $scope.moviesById = _.keyBy movies, 'id'
    console.log $scope.moviesById

  theaterPromise = Theater.get(theaterId: $stateParams.theaterId).$promise
  .then (theater) ->
    $scope.theater = theater

  $q.all [moviesPromise, theaterPromise]
  .then ->
    $scope.ready = true

  # TODO: move this in a directive
  $scope.back = ->
    $window.history.back()
