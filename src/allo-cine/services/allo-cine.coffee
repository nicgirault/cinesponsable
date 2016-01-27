angular.module 'Cinesponsable.alloCine'
.service 'AlloCine', (
  $resource
  ALLOCINE_API_URL
  ALLOCINE_PARTNER_TOKEN
) ->
  AlloCineShowTime = $resource ALLOCINE_API_URL + '/showtimelist?partner=:partner&format=json&theaters=:alloCineId'
  AlloCineTheater = $resource ALLOCINE_API_URL + '/theaterlist?partner=:partner&format=json&theaters=:alloCineId'

  getTheaterInfo: (code) ->
    AlloCineTheater.get {
      partner: ALLOCINE_PARTNER_TOKEN,
      alloCineId: code
    }
    .$promise.then (data) ->
      result = null
      if _.isArray data.feed?.theater
        result = _.find data.feed?.theater, code: code

        if result?
          result.alloCineId = code
      result

  getShowtimes: (alloCineId) ->
    AlloCineTheater.get {
      partner: ALLOCINE_PARTNER_TOKEN,
      alloCineId: alloCineId
    }
    .$promise.then (data) ->
      data?.feed?.theaterShowtimes[0]?.movieShowtimes
