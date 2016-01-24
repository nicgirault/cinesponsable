angular.module 'Cinesponsable.alloCine'
.service 'AlloCine', (
  $resource
  ALLOCINE_API_URL
  ALLOCINE_PARTNER_TOKEN
) ->
  AlloCineTheater = $resource ALLOCINE_API_URL + '/showtimelist?partner=:partner&format=json&theaters=:alloCineId'

  getTheaterInfo: (theater) ->
    AlloCineTheater.get {
      partner: ALLOCINE_PARTNER_TOKEN,
      alloCineId: theater.alloCineId
    }
    .$promise.then (data) ->
      if data.feed
        place = data.feed.theaterShowtimes[0]?.place?.theater
        theater.name = place?.name
        theater.address = place?.address
        theater.postalCode = place?.postalCode
        theater.city = place?.city
        theater.picture = place?.picture?.href
        theater.allocineLink = place?.link[0]?.href
        theater.geoloc = place?.geoloc
        theater.area = place?.area
      theater

  getShowtimes: (alloCineId) ->
    AlloCineTheater.get {
      partner: ALLOCINE_PARTNER_TOKEN,
      alloCineId: alloCineId
    }
    .$promise.then (data) ->
      data?.feed?.theaterShowtimes[0]?.movieShowtimes
