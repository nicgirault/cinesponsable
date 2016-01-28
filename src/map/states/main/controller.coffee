angular.module 'Cinesponsable.map'
.controller 'MapCtrl', (
  $scope
  theaters
  uiGmapGoogleMapApi
  Theater
  currentPosition
) ->
  $scope.theaters = theaters

  uiGmapGoogleMapApi.then (maps) ->
    $scope.map =
      center: currentPosition
      zoom: 11
  # $scope.events =
  #   dragend: (maps, eventName, args) ->
  #     newCenter =
  #       latitude: maps.center.G
  #       longitude: maps.center.K
  #     console.log newCenter, maps
  #     Theater.getClosestTheaters newCenter, 10
  #     .then (theaters) ->
  #       $scope.theaters = theaters
