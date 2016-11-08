angular.module 'Cinesponsable.map'
.config (
  $stateProvider
) ->
  $stateProvider
  .state 'base.tabs.map',
    url: '/map'
    templateUrl: 'map/states/main/view.html'
    controller: 'MapCtrl'
    data:
      tab: 'map'
    resolve:
      currentPosition: (position) ->
        position.get().then (position) ->
          latitude: position.coords.latitude
          longitude: position.coords.longitude
        .catch (err) ->
          latitude: 48.860779
          longitude: 2.340175
