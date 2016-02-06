angular.module 'Cinesponsable.common'
.controller 'BaseCtrl', ($scope, $state, theaters) ->
  $scope.theaters = theaters
  $scope.state = $state
  console.log $state.current
