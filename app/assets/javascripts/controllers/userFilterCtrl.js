"use strict";


/* this is reusable for the admin and staff user filtering */

angular.module("wrektranet.userFilterCtrl", [])

.controller('userFilterCtrl', [
  '$scope',
  'Restangular',
  'promiseTracker',
  function($scope, Restangular, promiseTracker) {
    // fixes weird history bug in chrome. clicking a user and going back
    // makes a json request instead of html
    Restangular.setRequestSuffix('?1');

    $scope.users = [];
    $scope.loadingTracker = promiseTracker();
    $scope.search = {};

    // pagination
    $scope.currentPage = 1;
    $scope.maxSize = 11;
    $scope.itemsPerPage = 20;

    $scope.category = null;
    $scope.status = 'active';

    $scope.filterByRole = function(row) {
      if ($scope.roleName) {
        return !!_.where(row.roles, { name: $scope.roleName }).length;
      } else {
        return true;
      }
    }

    $scope.concatenateRoles = function(roles) {
      return _.pluck(roles, 'full_name').join(', ')
    }

    $scope.init = function(baseUrl, itemsPerPage) {
      Restangular.setBaseUrl('/' + baseUrl);

      if (itemsPerPage) {
        $scope.itemsPerPage = itemsPerPage;
      }

      var promise = Restangular.one('users').getList()
        .then(function(users) {
          $scope.users = users;
        });

      $scope.$watch('category', function(newValue, oldValue) {
        if ($scope.search) {
          delete $scope.search.exec_staff;
          delete $scope.search.admin;

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
  }
]);