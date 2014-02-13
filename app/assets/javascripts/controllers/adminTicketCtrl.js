"use strict";

angular.module("wrektranet.adminTicketCtrl", [])

// container for list of tickets
.controller('adminTicketListCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/admin');

    // update contests for any appropriate tickets
    $scope.$on('updateContests', function(e, contest) {
      $scope.$broadcast('updateContest', contest);

      angular.forEach($scope.tickets, function(ticket) {
        if (ticket.contest.id === contest.id) {
          ticket.contest = contest;
        }
      });
    });

    $scope.addTicket = function() {
      var ticket, restangularTicket;

      ticket = {
        contest_id: $scope.contest.id,
        user_id: $scope.user_id
      };

      restangularTicket = Restangular
        .restangularizeElement(null, ticket, 'staff_tickets');

      restangularTicket
        .post()
        .then(function(newTicket) {
          if (newTicket.id !== false) {
            $scope.tickets.push(newTicket);
            $scope.user_id = null;
            $scope.$emit('updateContests', newTicket.contest);
          }
        });
    };
  }
])

// controller for individual ticket rows
.controller('adminTicketCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/admin');

    $scope.isContestFull = function() {
      var limit, total;

      limit = $scope.ticket.contest.staff_ticket_limit;
      total = $scope.ticket.contest.staff_count;
      return (limit - total === 0);
    };

    $scope.openEdit = function() {
      var newName = null;

      newName = prompt("Enter a custom name for this ticket:", $scope.ticket.display_name);

      if (newName !== null) {
        $scope.ticket.display_name = newName;
        $scope.saveName();
      }
    };

    $scope.revertName = function() {
      var restangularTicket = Restangular.
        restangularizeElement(null, $scope.ticket, 'staff_tickets');

      restangularTicket.display_name = null;
      restangularTicket.put();
    };

    $scope.saveName = function() {
      var restangularTicket = Restangular.
        restangularizeElement(null, $scope.ticket, 'staff_tickets');

      restangularTicket.put();
    };

    $scope.award = function() {
      var restangularTicket = Restangular.
        restangularizeElement(null, $scope.ticket, 'staff_tickets');

      restangularTicket.awarded = true;
      restangularTicket
        .put()
        .then(function(updatedTicket) {
          $scope.ticket.awarded = true;
          $scope.$emit('updateContests', updatedTicket.contest);
        });
    };

    $scope.unaward = function() {
      var restangularTicket = Restangular
        .restangularizeElement(null, $scope.ticket, 'staff_tickets');

      restangularTicket.awarded = false;
      restangularTicket
        .put()
        .then(function(updatedTicket) {
          $scope.ticket.awarded = false;
          $scope.$emit('updateContests', updatedTicket.contest);
        });
    };

    $scope.remove = function() {
      var restangularTicket = Restangular
        .restangularizeElement(null, $scope.ticket, 'staff_tickets');

      if (confirm("Are you sure you want to delete this signup?")) {
        restangularTicket
          .remove()
          .then(function() {
            _.remove($scope.tickets, $scope.ticket);
            $scope.ticket = null;
          });
      }
    };
  }
]);