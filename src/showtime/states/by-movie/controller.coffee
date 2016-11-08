angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeByMovieCtrl', (
  $scope
  $q
  $stateParams
  $window
  Showtime
  Movie
  Position
) ->
  $scope.ready = false

  Position.get().then (position) ->
    $q.all [
      Showtime.query
        filter:
          include: 'theater'
          where:
            movieId: $stateParams.movieId
            and: [
              datetime:
                gt: new Date()
            ,
              datetime:
                lt: moment().add(7, 'days').toDate()
            ]
            order: 'datetime ASC'
            position: "#{position.lat};#{position.lng}"
      .$promise
    ,
      Movie.get(movieId: $stateParams.movieId).$promise
    ]
  .then ([showtimes, movie]) ->
    for showtime in showtimes
      showtime.day = moment(showtime.datetime)
        .format('dddd D MMMM')
    $scope.theaters = _.keyBy showtimes, 'theaterId'
    $scope.movie = movie
    groupByDay = (showtime) ->
      moment(showtime.datetime).format('DD-MM-YY')
    $scope.groupedShowtimes = _.groupByMulti showtimes, ['theaterId', 'language', groupByDay]
    $scope.ready = true

  $scope.back = ->
    $window.history.back()
