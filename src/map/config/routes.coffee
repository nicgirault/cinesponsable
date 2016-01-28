angular.module 'Cinesponsable.map'
.config (
  $stateProvider
) ->
  $stateProvider
  .state 'base.map',
    url: '/map'
    templateUrl: 'map/states/main/view.html'
    controller: 'MapCtrl'
    data:
      tab: 'map'
    resolve:
      theaters: (Theater, position) ->
        Theater.query()
        # position.get().then (position) ->
        #   Theater.getClosestTheaters {
        #     latitude: position.coords.latitude
        #     longitude: position.coords.longitude
        #   }, 10
        # .catch (err) ->
        #   # fallback on Paris
        #   Theater.getClosestTheaters {
        #     latitude: 48.860779
        #     longitude: 2.340175
        #   }, 50
      currentPosition: (position) ->
        position.get().then (position) ->
          latitude: position.coords.latitude
          longitude: position.coords.longitude
        .catch (err) ->
          latitude: 48.860779
          longitude: 2.340175
