angular.module 'Cinesponsable.search'
.controller 'searchBarCtrl', ($scope, $state, Theater) ->
  $scope.searchTextChange = (text) ->
    return

  $scope.itemChange = (item) ->
    if item.constructor?.name is 'Theater'
      $state.go 'base.showtime', theaterId: item.code
    return

  repos = [
    {
      'name': 'Angular 1'
      'url': 'https://github.com/angular/angular.js'
      'watchers': '3,623'
      'forks': '16,175'
    }
    {
      'name': 'Angular 2'
      'url': 'https://github.com/angular/angular'
      'watchers': '469'
      'forks': '760'
    }
    {
      'name': 'Angular Material'
      'url': 'https://github.com/angular/material'
      'watchers': '727'
      'forks': '1,241'
    }
    {
      'name': 'Bower Material'
      'url': 'https://github.com/angular/bower-material'
      'watchers': '42'
      'forks': '84'
    }
    {
      'name': 'Material Start'
      'url': 'https://github.com/angular/material-start'
      'watchers': '81'
      'forks': '303'
    }
  ]
  repos.map (repo) ->
    repo.value = repo.name.toLowerCase()
    repo
  $scope.simulateQuery = false
  $scope.isDisabled = false
