"use strict";

angular.module("wrektranet.adminUserCtrl", [])

.controller('adminUserCtrl', [
  '$scope',
  'Restangular',
  'promiseTracker',
  function($scope, Restangular, promiseTracker) {
    Restangular.setBaseUrl('/admin');

    $scope.users = [];
    $scope.loadingTracker = promiseTracker();
    $scope.search = {};

    // pagination
    $scope.currentPage = 1;
    $scope.maxSize = 5;
    $scope.itemsPerPage = 20;

    $scope.category = null;
    $scope.status = 'active';

    var promise = Restangular.one('users').getList()
      .then(function(users) {
        $scope.users = users;
      });

    $scope.$watch('category', function(newValue, oldValue) {
      if ($scope.search) {
        $scope.search.exec_staff = "";
        $scope.search.admin = "";

        switch (newValue) {
          case 'admin':
            $scope.search.admin = "true";
            break;
          case 'exec_staff':
            $scope.search.exec_staff = "true";
            break;
        }
      }
    });

    $scope.loadingTracker.addPromise(promise);
  }
]);