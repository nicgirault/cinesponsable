angular.module 'Cinesponsable.theater'
.config ($stateProvider) ->
  $stateProvider
  .state 'base.theaters',
    url: '/theaters'
    templateUrl: 'theater/states/list/view.html'
    controller: 'TheaterListCtrl'
    data:
      tab: 'theaters'
