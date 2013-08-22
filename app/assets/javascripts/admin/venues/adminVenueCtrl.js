"use strict";

angular.module("wrektranet.adminVenueCtrl", [])

.controller('adminVenueCtrl', [
  '$scope',
  function($scope) {
    $scope.newContact = {
      email: ""
    };

    $scope.addContact = function(event) {
      var contact = angular.copy($scope.newContact);
      $scope.venue.contacts.push(contact);
      $scope.newContact.email = "";

      event.preventDefault();
    };

    $scope.deleteContact = function(contact) {
      if (contact.id) {
        // set destroy flag to true
        contact.destroy = 1;
      } else {
        // unsaved contact, remove it entirely
        $scope.venue.contacts.splice($.inArray(contact, $scope.venue.contacts), 1);
      }
    }
  }
]);