"use strict";

angular.module("wrektranet.airContestCtrl", [])

.controller('airContestCtrl', [
  '$scope',
  'Restangular',
  '$window',
  function($scope, Restangular, $window) {
    var resetTicket;
    Restangular.setBaseUrl('/air');

    resetTicket = function() {
      $scope.newTicket = {
        name: "",
        phone: ""  
      };
    };

    $scope.updateTickets = function() {
      Restangular.
        one('contests', $scope.contest.id).
        all('listener_tickets').
        getList()
        .then(function(tickets) {
          $scope.contest.listener_tickets = tickets;
        });
    };

    $scope.addTicket = function() {
      var contest = Restangular.one('contests', $scope.contest.id);

      contest.post('listener_tickets', $scope.newTicket).then(function() {
        resetTicket();
        $scope.updateTickets();
      }, function() {
        $scope.updateTickets();
      });
    };

    $scope.deleteTicket = function(ticket) {
      var confirmDelete = confirm('Are you sure you want to delete this ticket?');

      if (confirmDelete) {
        Restangular.
          one('listener_tickets', ticket.id).
          remove().
          then(function() {
            $scope.updateTickets();
          });
      }
    };

    $window.onbeforeunload = function() {
      if ($scope.newTicket.name.length > 0) {
        return 'You forgot to save a listener ticket!';
      }
    };

    resetTicket();
  }
]);