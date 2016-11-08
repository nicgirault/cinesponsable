angular.module 'Cinesponsable.common'
.config (
  $stateProvider
) ->

  $stateProvider
  .state 'base',
    templateUrl: 'common/states/base/view.html'
    controller: 'BaseCtrl'
    abstract: true

  .state 'base.tabs',
    templateUrl: 'common/states/tabs/view.html'
    controller: 'TabsCtrl'
    abstract: true
