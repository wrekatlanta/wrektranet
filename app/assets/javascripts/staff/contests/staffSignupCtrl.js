"use strict";

angular.module("wrektranet.staffSignupCtrl", [])

.controller('staffSignupCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/staff');

    $scope.signup = function(contest) {
      var ticket = {
        staff_ticket: {
          contest_id: contest.id
        }
      }

      Restangular.all('staff_tickets').post(ticket).then(function() {
        contest.signed_up = true;
      }, function() {
        contest.signed_up = false;
      });
    };
  }
]);