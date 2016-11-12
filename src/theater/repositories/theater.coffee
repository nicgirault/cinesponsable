angular.module 'Cinesponsable.theater'
.service 'TheaterRepository', (Theater) ->
  pageCount = 20

  getByPosition: (position, page) ->
    page = 0 unless page?
    Theater.query
      filter:
        where:
          geopoint:
            near: [position.lat, position.lng]
        limit: pageCount
        skip: page * pageCount
    .$promise
    .then (_theaters_) ->
      theaters = []
      angular.forEach _theaters_, (theater) ->
        theaters.push theater
      theaters
