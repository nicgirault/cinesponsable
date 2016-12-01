angular.module 'Cinesponsable.movie'
.config (
  $stateProvider
) ->
  $stateProvider
  .state 'base.movieList',
    url: '/movie?q'
    templateUrl: 'movie/states/list/view.html'
    controller: 'MovielistCtrl'
    reloadOnSearch: false
    data:
      tab: 'movies'

  .state 'base.movieDetails',
    url: '/movie/:movieId'
    templateUrl: 'movie/states/details/view.html'
    controller: 'MovieDetailsCtrl'
