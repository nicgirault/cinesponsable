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
      enableHighAccuracy: true
      timeout: 5000
      maximumAge: 0
    )
    deferred.promise
