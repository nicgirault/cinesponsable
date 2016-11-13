angular.module 'Cinesponsable.common'
.controller 'BaseCtrl', ($scope, $state, PLATEFORM) ->
  $scope.state = $state
  $scope.PLATEFORM = PLATEFORM
  return
