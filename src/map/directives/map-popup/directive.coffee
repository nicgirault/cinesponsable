angular.module 'Cinesponsable.map'
.directive 'mapPopup', ->
  restrict: 'E'
  templateUrl: 'map/directives/map-popup/view.html'
  scope:
    title: '@'
    subtitle: '@'
    id: '@'
