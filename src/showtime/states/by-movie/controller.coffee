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
      for showtime in showtimes
        showtime.datetimeString = moment(showtime.datetime)
          .format('dddd D MMMM [à] HH[h]mm')
      $scope.showtimes = showtimes
