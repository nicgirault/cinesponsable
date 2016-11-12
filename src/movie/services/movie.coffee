angular.module 'Cinesponsable.theater'
.service 'MovieRepository', (Movie) ->
  cache = {}
  pageCount = 10

  onTheBill: (page) ->
    unless cache[page]?
      cache[page] = Movie.onTheBill
        skip: page * pageCount
        limit: pageCount
      .$promise
      .then (movies) ->
        for movie in movies
          if movie.poster?
            url = movie.poster.split('/')
            url.splice(3, 0, 'cx_240_320')
            movie.poster = url.join('/')
        movies

    return cache[page]
