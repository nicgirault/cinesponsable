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
      theaters: (Theater, AlloCine, $q) ->
        Theater.query()
        .then (theaters) ->
          promises = []
          for theater in theaters
            promises.push AlloCine.getTheaterInfo theater
          $q.all promises
          .then (completedTheaters) ->
            _.each completedTheaters, (theater) ->
              theater.geoloc =
                latitude: theater.geoloc?.lat
                longitude: theater.geoloc?.long
            completedTheaters
