"use strict";

angular.module("wrektranet.controllers", [
  "wrektranet.adminVenueCtrl",
  "wrektranet.airContestCtrl",
  "wrektranet.staffSignupCtrl",
  "wrektranet.adminTicketCtrl",
  "wrektranet.airTransmitterLogCtrl",
  "wrektranet.airPlaylistCtrl",
  "wrektranet.listenerLogsCtrl"
]);

angular.module("wrektranet", [
  "restangular",
  "ui.keypress",
  "ng-rails-csrf",
  "ajoslin.promise-tracker",
  "wrektranet.controllers"
]);