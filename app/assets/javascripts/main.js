"use strict";

angular.module("wrektranet.controllers", [
  "wrektranet.adminVenueCtrl",
  "wrektranet.airContestCtrl"
]);

angular.module("wrektranet", [
  "restangular",
  "ui.keypress",
  "ng-rails-csrf",
  "wrektranet.controllers"
]);