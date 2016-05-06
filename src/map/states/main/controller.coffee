angular.module 'Cinesponsable.map'
.controller 'MapCtrl', (
  $scope
  Theater
  currentPosition
) ->
  angular.extend $scope,
    userPosition:
      lat: currentPosition.latitude
      lng: currentPosition.longitude
      zoom: 13
    data: markers: {}

  Theater.query().$promise.then (theaters) ->
    markers = {}
    for theater in theaters
      markers[theater.code] =
        lat: theater.geopoint.lat
        lng: theater.geopoint.lng
        compileMessage: true
        message: "<map-popup title='#{theater.name}' subtitle='#{theater.address} #{theater.postalCode} #{theater.city}' code='#{theater.code}'>"
    $scope.theaters = theaters

    $scope.data.markers = {}
    angular.extend $scope.data, markers: markers
    return

  # $scope.events =
  #   dragend: (maps, eventName, args) ->
  #     newCenter =
  #       latitude: maps.center.G
  #       longitude: maps.center.K
  #     console.log newCenter, maps
  #     Theater.getClosestTheaters newCenter, 10
  #     .then (theaters) ->
  #       $scope.theaters = theaters
