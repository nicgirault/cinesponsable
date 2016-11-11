angular.module 'Cinesponsable.map'
.service 'position', ($q) ->
  get: ->
    deferred = $q.defer()
    navigator.geolocation.getCurrentPosition(
      (position) ->
        deferred.resolve position
    , (err) ->
      console.warn err
      deferred.reject err
    ,
      timeout: 20000
      maximumAge: 10000
    )
    deferred.promise
