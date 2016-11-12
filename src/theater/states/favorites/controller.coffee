angular.module 'Cinesponsable.theater'
.controller 'FavoritesListCtrl', ($scope, $state, TheaterRepository, Favorites) ->
  $scope.ready = false

  TheaterRepository.getFavorites()
    .then (theaters) ->
      $scope.theaters = theaters
      $scope.ready = true

  $scope.showtime = (theater) ->
    $state.go 'base.showtimeByTheater', {theaterId: theater.id}

  $scope.toggleFavorites = (theaterId) ->
    Favorites.toggle(theaterId)
    $scope.favorites = Favorites.get()

  $scope.favorites = Favorites.get()
  return
