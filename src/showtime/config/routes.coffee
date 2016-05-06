angular.module 'Cinesponsable.showtime'
.config (
  $stateProvider
) ->

  $stateProvider
  .state 'base.showtime',
    url: '/theater/:theaterId/showtime'
    templateUrl: 'showtime/states/theater-showtime/view.html'
    controller: 'ShowtimeCtrl'
    resolve:
      showtimes: (Theater, AlloCine, $stateParams) ->
        return null unless $stateParams.theaterId?
        if $stateParams.theaterId?
          AlloCine.getShowtimes $stateParams.theaterId
      theater: (Theater, AlloCine, $stateParams) ->
        return null unless $stateParams.theaterId?
        theater =
          alloCineId: $stateParams.theaterId
        AlloCine.getTheaterInfo theater
    params:
      theater: null

  .state 'base.showtimeList',
    url: '/showtime?movieId'
    templateUrl: 'showtime/states/list/view.html'
    controller: 'ShowtimeListCtrl'
