angular.module 'Cinesponsable.theater'
.factory 'Theater', (Parse) ->
  class Cinema extends Parse.Model
    @configure "Cinema", "alloCineId"
