angular.module 'Cinesponsable.alloCine'
.service 'AlloCine', (
  $resource
  ALLOCINE_API_URL
  ALLOCINE_PARTNER_TOKEN
  Movie
  $q
) ->
  AlloCineShowTime = $resource ALLOCINE_API_URL + '/showtimelist?partner=:partner&format=json&theaters=:alloCineId'
  AlloCineTheater = $resource ALLOCINE_API_URL + '/theaterlist?partner=:partner&format=json&theaters=:alloCineId'
  AlloCineMovieList = $resource ALLOCINE_API_URL + '/movielist?partner=:partner&count=:count&order=theatercount&format=json&filter=nowshowing'

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
    AlloCineShowTime.get {
      partner: ALLOCINE_PARTNER_TOKEN,
      alloCineId: alloCineId
    }
    .$promise.then (data) ->
      data?.feed?.theaterShowtimes[0]?.movieShowtimes

  fetchMovies: ->
    AlloCineMovieList.get {
      partner: ALLOCINE_PARTNER_TOKEN,
      count: 1
    }
    .$promise.then (data) ->
      totalResults = data?.feed?.totalResults
      return unless totalResults?
      AlloCineMovieList.get {
        partner: ALLOCINE_PARTNER_TOKEN,
        count: totalResults
      }
      .$promise.then (data) ->
        movies = data?.feed?.movie
        async.eachSeries movies, (m, callback) ->
          movie = new Movie()
          movie.type = m.movieType.$
          movie.originalTitle = m.originalTitle
          movie.title = m.title
          movie.genres = (genre.$ for genre in m.genre)
          movie.synopsisShort = m.synopsisShort
          movie.casting = m.castingShort
          movie.poster = m.poster?.href
          movie.save().then ->
            console.log 'saving movie: ' + m.originalTitle, movie
            callback()
