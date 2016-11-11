angular.module 'Cinesponsable.map'
.controller 'MapCtrl', (
  $scope
  Theater
  Position
) ->
  Position.get().then (position) ->
    angular.extend $scope,
      defaults:
        tileLayer: 'https://api.mapbox.com/styles/v1/nicolasg6/civd0vm9z00d22imgufcyru6k/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoibmljb2xhc2c2IiwiYSI6ImNpdmQwbjl1dTAxZWwydHBka2dxODdsNmwifQ.Bo62UFRBwjEXlJNp_g2KVg'
      userPosition:
        lat: position.lat
        lng: position.lng
        zoom: 13
      data: markers: {}

    Theater.query().$promise.then (theaters) ->
      markers = {}
      for theater in theaters
        markers[theater.code] =
          lat: theater.geopoint.lat
          lng: theater.geopoint.lng
          compileMessage: true
          message: "<map-popup title='#{theater.name}' subtitle='#{theater.address} #{theater.postalCode} #{theater.city}' id='#{theater.id}'>"
      $scope.theaters = theaters

      $scope.data.markers = {}
      angular.extend $scope.data, markers: markers
      $scope.ready = true
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
