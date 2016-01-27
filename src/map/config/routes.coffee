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
