"use strict";

angular.module("wrektranet.staffSignupCtrl", [])

.controller('staffSignupCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/staff');

    $scope.isContestFull = function(contest) {
      return (contest.staff_ticket_limit - contest.staff_count) === 0;
    };

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