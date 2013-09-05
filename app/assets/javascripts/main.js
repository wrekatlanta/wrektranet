"use strict";

angular.module("wrektranet.controllers", [
  "wrektranet.adminVenueCtrl",
  "wrektranet.airContestCtrl",
  "wrektranet.staffSignupCtrl",
  "wrektranet.adminTicketCtrl"
]);

angular.module("wrektranet", [
  "restangular",
  "ui.keypress",
  "ng-rails-csrf",
  "wrektranet.controllers"
]);