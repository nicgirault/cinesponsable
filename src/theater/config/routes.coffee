angular.module 'Cinesponsable.theater'
.config ($stateProvider) ->
  $stateProvider

  .state 'base.tabs.theaters',
    url: '/theaters'
    templateUrl: 'theater/states/list/view.html'
    controller: 'TheaterListCtrl'
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
