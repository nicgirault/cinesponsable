angular.module 'Cinesponsable.showtime'
.controller 'DetailsCtrl', ($scope, showtime, $mdDialog) ->
  $scope.showtime = showtime
  $scope.releaseDate = moment(showtime.onShow.movie.release.releaseDate).format("dddd D MMMM YYYY")
  for seance in $scope.showtime.scr
    seance.date = moment(seance.d).format("dddd D MMMM YYYY")
    times = (time.$ for time in seance.t)
    seance.time = times.join(', ')
  genres = (genre.$ for genre in showtime.onShow.movie.genre)
  $scope.genres = genres.join(', ')
  $scope.cancel = ->
    $mdDialog.cancel()
  $scope.versionLabel =
    true: "original"
    false: "doublage"
