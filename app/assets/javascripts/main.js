"use strict";

angular.module("wrektranet.controllers", [
  "wrektranet.adminVenueCtrl",
  "wrektranet.airContestCtrl",
  "wrektranet.staffSignupCtrl",
  "wrektranet.adminTicketCtrl",
  "wrektranet.airTransmitterLogCtrl",
  "wrektranet.airPlaylistCtrl",
  "wrektranet.airProgramLogCtrl",
  "wrektranet.adminProgramLogCtrl",
  "wrektranet.listenerLogsCtrl",
  "wrektranet.userFilterCtrl"
]);

angular.module("wrektranet.filters", [
  "wrektranet.rangeFilter",
  "wrektranet.startFromFilter"
]);

angular.module("wrektranet", [
  "restangular",
  "ui.keypress",
  "ui.bootstrap",
  "ng-rails-csrf",
  "ajoslin.promise-tracker",
  "wrektranet.filters",
  "wrektranet.controllers"
]);