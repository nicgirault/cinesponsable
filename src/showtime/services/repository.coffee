angular.module 'Cinesponsable.theater'
.service 'ShowtimeRepository', (Showtime) ->
  cache = {}

  getShowtimes = (theaterId) ->
    unless cache[theaterId]?
      cache[theaterId] = Showtime.query
        filter:
          where:
            and: [
              datetime:
                gt: new Date()
            ,
              datetime:
                lt: moment().add(7, 'days').toDate()
            ]
            theaterId: theaterId
          order: 'datetime ASC'
      .$promise

    return cache[theaterId]

  groupByDay = (showtime) ->
    moment(showtime.datetime).format('DD-MM-YY')

  getByMovie: (theaterId) ->
    getShowtimes(theaterId).then (showtimes) ->
      for showtime in showtimes
        showtime.day = moment(showtime.datetime).format('dddd D MMMM')

      return _.groupByMulti showtimes, ['movieId', 'language', groupByDay]

  getByDate: (theaterId) ->
    getShowtimes(theaterId).then (showtimes) ->
      for showtime in showtimes
        showtime.day = moment(showtime.datetime).format('dddd D MMMM')

      return _.groupByMulti showtimes, [groupByDay, 'movieId']
