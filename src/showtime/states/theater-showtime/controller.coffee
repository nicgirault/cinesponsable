angular.module 'Cinesponsable.showtime'
.controller 'ShowtimeCtrl', ($scope, theater, showtimes, $mdMedia, $mdDialog) ->
  $scope.showtimes = showtimes
  $scope.theater = theater

  $scope.showDetails = (showtime, event) ->
    useFullScreen = ($mdMedia('sm') || $mdMedia('xs'))
    $mdDialog.show
      controller: 'DetailsCtrl'
      templateUrl: 'showtime/states/theater-showtime/details.html'
      parent: angular.element(document.body)
      targetEvent: event
      clickOutsideToClose: true
      fullscreen: useFullScreen
      resolve:
        showtime: -> showtime
