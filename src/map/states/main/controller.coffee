angular.module 'Cinesponsable.map'
.controller 'MapCtrl', (
  $scope
  theaters
  Theater
  currentPosition
) ->
  angular.extend $scope,
    userPosition:
      lat: currentPosition.latitude
      lng: currentPosition.longitude
      zoom: 8
    data: markers: {}

  markers = {}
  for theater in theaters
    markers[theater.code] =
      lat: theater.geopoint.latitude
      lng: theater.geopoint.longitude
      compileMessage: true
      message: "<map-popup title='#{theater.name}' subtitle='#{theater.address} #{theater.locality.postalCode} #{theater.locality.name}' code='#{theater.code}'>"

  $scope.addMarkers = ->
    $scope.data.markers = {}
    angular.extend $scope.data, markers: markers
    return
  $scope.addMarkers()

  # $scope.events =
  #   dragend: (maps, eventName, args) ->
  #     newCenter =
  #       latitude: maps.center.G
  #       longitude: maps.center.K
  #     console.log newCenter, maps
  #     Theater.getClosestTheaters newCenter, 10
  #     .then (theaters) ->
  #       $scope.theaters = theaters
