angular.module 'Cinesponsable.theater'
.service 'Favorites', (localStorageService) ->
  favorites = localStorageService.get('favorites')
  unless favorites?
    localStorageService.set('favorites', {})

  toggle: (theaterId) ->
    favorites = localStorageService.get('favorites')
    if favorites[theaterId]?
      favorites[theaterId] = undefined
    else
      favorites[theaterId] = true
    localStorageService.set('favorites', favorites)
  get: ->
    return localStorageService.get('favorites')
