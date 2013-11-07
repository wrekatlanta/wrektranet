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

      if ($scope.contest.id === contest.id) {
        $scope.contest = contest;
      }
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

    $scope.isContestFull = function() {
      var limit, total;

      limit = $scope.contest.staff_ticket_limit;
      total = $scope.contest.staff_count;
      return (limit - total === 0);
    };
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
      if ($scope.ticket.contest_id === contest.id) {
        $scope.ticket.contest = contest;
      }
    });

    $scope.isEditingName = false;
    $scope.nameBackup = null;

    $scope.isContestFull = function() {
      var limit, total;

      limit = $scope.ticket.contest.staff_ticket_limit;
      total = $scope.ticket.contest.staff_count;
      return (limit - total === 0);
    };

    $scope.openEdit = function() {
      $scope.nameBackup = $scope.ticket.display_name;

      if (!$scope.ticket.display_name) {
        $scope.ticket.display_name = '';
      }

      $scope.isEditingName = true;
    };

    $scope.cancelEdit = function() {
      $scope.ticket.display_name = $scope.nameBackup;
      $scope.isEditingName = false;
    };

    $scope.revertName = function() {
      var restangularTicket = Restangular.
        restangularizeElement(null, $scope.ticket, 'staff_tickets');

      restangularTicket.display_name = null;
      restangularTicket
        .put()
        .then(function() {
          $scope.isEditingName = false;
        });
    };

    $scope.saveName = function() {
      var restangularTicket = Restangular.
        restangularizeElement(null, $scope.ticket, 'staff_tickets');

      restangularTicket
        .put()
        .then(function() {
          $scope.isEditingName = false;
        });
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
  }
]);