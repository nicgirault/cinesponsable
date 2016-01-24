angular.module 'Cinesponsable.common'
.controller 'BaseCtrl', ($scope, $state) ->
  $scope.state = $state
  console.log $state.current
