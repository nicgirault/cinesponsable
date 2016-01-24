angular.module 'Cinesponsable.map'
.config (
  $stateProvider
) ->
  $stateProvider
  .state 'map',
    url: '/map'
    templateUrl: 'map/states/main/view.html'
    controller: 'MapCtrl'
    resolve:
      theaters: (Theater, AlloCine) ->
        Theater.query()
        .then (theaters) ->
          for theater in theaters
            AlloCine.getTheaterInfo theater
          theaters
