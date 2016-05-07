angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', (
  $scope
  $mdMedia
  $mdDialog
  $stateParams
  Showtime
) ->

  Showtime.query
    filter:
      include: 'movie'
      where:
        datetime:
          gt: new Date()
        theaterId: $stateParams.theaterId
      order: 'datetime ASC'
  .$promise.then (showtimes) ->
    for showtime in showtimes
      showtime.datetimeString = moment(showtime.datetime)
        .format('dddd D MMMM [à] HH[h]mm')
    $scope.showtimes = showtimes
    $scope.ready = true
