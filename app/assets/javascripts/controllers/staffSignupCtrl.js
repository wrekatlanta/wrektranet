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

      Restangular
        .all('staff_tickets')
        .post(ticket)
        .then(function(ticket) {
          contest.signed_up = true;
          contest.ticket_id = ticket.id;
        }, function() {
          contest.signed_up = false;
        });
    };

    $scope.remove = function(contest) {
      var ticket = contest.ticket_id;

      Restangular
        .one('staff_tickets', ticket)
        .remove()
        .then(function() {
          contest.signed_up = false;
          contest.ticket_id = null;
        });
    }
  }
]);