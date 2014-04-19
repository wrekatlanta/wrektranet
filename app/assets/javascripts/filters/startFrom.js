"use strict";

angular.module("wrektranet.startFromFilter", [])

.filter('startFrom', function() {
  return function(input, start) {
    start = parseInt(start);
    return input.slice(start);
  }
});