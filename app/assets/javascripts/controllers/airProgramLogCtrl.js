"use strict";

angular.module("wrektranet.airProgramLogCtrl", [])

.controller('airProgramLogCtrl', [
  '$scope',
  '$sce',
  '$interval',
  function($scope, $sce, $interval) {
    // in order to bind HTML, we need to mark it as trusted first
    $scope.trustedHtml = function(html) {
      return $sce.trustAsHtml(html);
    };

    $scope.isSoon = function(occurrence) {
      var timeDifference = (new Date() - new Date(occurrence.time)) / 1000,
          maxMinutesApart = 15;

      console.log(timeDifference);

      return (Math.abs(timeDifference) < (maxMinutesApart * 60));
    };

    $scope.calculateIsSoon = function() {
      angular.forEach($scope.program_log.occurrences, function(occurrence) {
        occurrence.isSoon = $scope.isSoon(occurrence);
      });
    }

    $interval(function() {
      $scope.calculateIsSoon();
    }, 1000 * 30);
  }
]);