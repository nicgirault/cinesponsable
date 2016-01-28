angular.module 'Cinesponsable.alloCine'
.controller 'AlloCineAdminCtrl', ($scope, theaterIds, AlloCine, Theater) ->
  $scope.fetchTheaters = ->
    for code in theaterIds
      console.log "handling #{code}"
      AlloCine.getTheaterInfo code
      .then (info) ->
        return unless info
        theater = new Theater({
          code: info.code
          name: info.name
          address: info.address
          locality:
            name: info.city
            postalCode: info.postalCode
          state: info.area
          country: "France"
          geopoint: new Parse.GeoPoint
            latitude: info.geoloc?.lat
            longitude: info.geoloc?.long
          pictures: []
          hasPRMAccess: if info.hasPRMAccess is 1 then true else false
          screenNumber: info.screenCount
        })
        if info.picture?.href?
          theater.pictures.push info.picture.href
        theater.save()
