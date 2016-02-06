angular.module 'Cinesponsable.search'
.directive 'searchBar', ->
  restrict: 'E'
  templateUrl: 'search/directives/search-bar/view.html'
  controller: 'searchBarCtrl'
