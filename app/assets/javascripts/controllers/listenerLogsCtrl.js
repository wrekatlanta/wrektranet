"use strict";

angular.module("wrektranet.listenerLogsCtrl", [])

.controller('listenerLogsCtrl', [
  '$scope',
  'Restangular',
  '$timeout',
  function($scope, Restangular, $timeout) {
    Restangular.setBaseUrl('/staff');

    // Init placeholders
    $scope.main_128 = '--';
    $scope.hd2_128 = '--';
    $scope.main_24 = '--';

    // Our 'interval' variable
    var pollTimeout;


    var getVals = function() {

      // Get current vals and assign to proper place.
      Restangular.all('listener_logs').customGET('current').then(function(current) {
        $scope.main_128 = current.main_128;
        $scope.main_24 = current.main_24;
        $scope.hd2_128 = current.hd2_128;
      }, function() {
        $scope.main_128 = '--';
        $scope.hd2_128 = '--';
        $scope.main_24 = '--';
      });

      // Call again in 10 seconds
      pollTimeout = $timeout(getVals, 10000);
    };

    getVals();
  }
]);