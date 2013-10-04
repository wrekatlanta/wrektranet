"use strict";

angular.module("wrektranet.airTransmitterLogCtrl", [])

.controller('airTransmitterLogCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/air');


    var signLog = function() {

    };
    
  }
]);