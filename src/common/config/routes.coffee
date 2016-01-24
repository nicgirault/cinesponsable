angular.module 'Cinesponsable.common'
.config (
  $stateProvider
) ->

  $stateProvider
  .state 'base',
    templateUrl: 'common/states/base/view.html'
    abstract: true
