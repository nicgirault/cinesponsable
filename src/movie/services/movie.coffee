angular.module 'Cinesponsable.theater'
.service 'MovieService', (Movie) ->
  onTheBillMovies = null

  onTheBill: ->
    unless onTheBillMovies?
      onTheBillMovies = Movie.onTheBill().$promise

    return onTheBillMovies
