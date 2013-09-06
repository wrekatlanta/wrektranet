"use strict";

angular.module("wrektranet.adminTicketCtrl", [])

// container for list of tickets
.controller('adminTicketListCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/admin');

    // notifies all tickets down if they need to update their contest object
    $scope.$on('updateContests', function(e, contest) {
      $scope.$broadcast('updateContest', contest);
    });
  }
])

// controller for individual ticket rows
.controller('adminTicketCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/admin');

    // updates the ticket's contest if the ID is the same
    $scope.$on('updateContest', function(e, contest) {
      console.log('ticket: ' + $scope.ticket.contest_id);
      console.log('contest: ' + contest.id);
      if ($scope.ticket.contest_id === contest.id) {
        $scope.ticket.contest = contest;
      }
    });

    $scope.isContestFull = function() {
      var limit, total;

      limit = $scope.ticket.contest.staff_ticket_limit;
      total = $scope.ticket.contest.staff_count;
      return (limit - total === 0);
    };

    $scope.award = function(ticket) {
      var restangularTicket = Restangular.
        restangularizeElement(null, ticket, 'staff_tickets');

      restangularTicket.awarded = true;
      restangularTicket
        .put()
        .then(function(updatedTicket) {
          ticket.awarded = true;
          $scope.$emit('updateContests', updatedTicket.contest);
        });
    };

    $scope.unaward = function(ticket) {
      var restangularTicket = Restangular
        .restangularizeElement(null, ticket, 'staff_tickets');

      restangularTicket.awarded = false;
      restangularTicket
        .put()
        .then(function(updatedTicket) {
          ticket.awarded = false;
          $scope.$emit('updateContests', updatedTicket.contest);
        });
    };
  }
]);