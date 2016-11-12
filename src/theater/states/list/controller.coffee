angular.module 'Cinesponsable.theater'
.controller 'TheaterListCtrl', ($scope, $state, TheaterRepository, Position, Favorites) ->
  $scope.ready = false
  $scope.theaters = []

  page = 0
  allIsLoaded = false
  loadingPromise = null

  Position.get().then (position) ->
    loadingPromise = TheaterRepository.getByPosition(position, page)
    .then (theaters) ->
      loadingPromise = null
      page++
      $scope.theaters = $scope.theaters.concat theaters
      $scope.ready = true

    $scope.loadMore = ->
      return if allIsLoaded or loadingPromise?
      loadingPromise = TheaterRepository.getByPosition(position, page)
      .then (theaters) ->
        loadingPromise = null
        return allIsLoaded = true if theaters.length is 0
        page++
        $scope.theaters = $scope.theaters.concat theaters

  $scope.showtime = (theater) ->
    $state.go 'base.showtimeByTheater', {theaterId: theater.id}

  $scope.addToFavorites = (theaterId) ->
    Favorites.toggle(theaterId)
    $scope.favorites = Favorites.get()

  $scope.favorites = Favorites.get()
