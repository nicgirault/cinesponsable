angular.module 'Cinesponsable.map'
.controller 'MapCtrl', (
  $scope
  theaters
  uiGmapGoogleMapApi
) ->
  $scope.theaters = theaters

  uiGmapGoogleMapApi.then (maps) ->
    $scope.map =
      center:
        latitude: 48.858181
        longitude: 2.335000
      zoom: 13
  $scope.events =
    dragend: (maps, eventName, args) ->
      newCenter =
        latitude: maps.center.A
        longitude: maps.center.F
