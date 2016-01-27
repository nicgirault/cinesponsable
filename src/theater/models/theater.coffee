angular.module 'Cinesponsable.theater'
.factory 'Theater', (Parse) ->
  class Theater extends Parse.Model
    @configure(
      "Theater",
      "code",
      "name",
      "address",
      "locality"
      "state",
      "country",
      "geo",
      "pictures",
      "hasPRMAccess",
      "screenNumber"
    )
