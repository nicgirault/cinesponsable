angular.module 'Cinesponsable.showtime'
.config (
  $stateProvider
) ->

  $stateProvider
  .state 'base.showtimeByTheater',
    url: '/theater/:theaterId/showtime'
    templateUrl: 'showtime/states/by-theater/view.html'
    controller: 'ShowtimeCtrl'

  .state 'base.showtimeByMovie',
    url: '/movie/:movieId/showtime'
    templateUrl: 'showtime/states/by-movie/view.html'
    controller: 'ShowtimeByMovieCtrl'
    data:
      tab: 'movies'
