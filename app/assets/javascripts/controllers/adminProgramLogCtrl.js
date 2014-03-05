"use strict";

angular.module("wrektranet.adminProgramLogCtrl", [])

.controller('adminProgramLogCtrl', [
  '$scope',
  function($scope) {
    $scope.newContact = {
      email: ""
    };

    $scope.addContact = function(event) {
      var contact = angular.copy($scope.newContact);
      event.preventDefault();

      if (contact.email.length === 0 || $scope.venueForm.newContactEmail.$invalid) {
        return false;
      }

      $scope.venue.contacts.push(contact);
      $scope.newContact.email = "";
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