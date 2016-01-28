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
      "geopoint",
      "pictures",
      "hasPRMAccess",
      "screenNumber"
    )

    @getClosestTheaters = (geopoint, limit = 10) ->
      @query
        where:
          geopoint:
            $nearSphere:
              __type: "GeoPoint"
              latitude: geopoint.latitude
              longitude: geopoint.longitude
        limit: limit
