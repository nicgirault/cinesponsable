angular.module 'Cinesponsable.common'
.service 'Position', (position) ->
    get: ->
      position.get().then (position) ->
        lat: position.coords.latitude
        lng: position.coords.longitude
      .catch (err) ->
        lat: 48.860779
        lng: 2.340175
