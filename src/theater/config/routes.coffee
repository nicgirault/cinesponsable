angular.module 'Cinesponsable.theater'
.config ($stateProvider) ->
  $stateProvider

  .state 'base.tabs.theaters',
    url: '/theaters?q'
    templateUrl: 'theater/states/list/view.html'
    controller: 'TheaterListCtrl'
    reloadOnSearch: false
    data:
      tab: 'theaters'
      subtab: 'theaters'

  .state 'base.tabs.favorites',
    url: '/favorites'
    templateUrl: 'theater/states/favorites/view.html'
    controller: 'FavoritesListCtrl'
    data:
      tab: 'theaters'
      subtab: 'favorites'
