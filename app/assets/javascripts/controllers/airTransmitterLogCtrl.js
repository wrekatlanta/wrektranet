"use strict";

angular.module("wrektranet.airTransmitterLogCtrl", [])

.controller('airTransmitterLogCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/air');

    // add leading zero
    var padNumber = function(number) {
      return number < 10 ? '0' + number : number;
    };

    var resetLog = function() {
      var time = new Date(),
          hours = padNumber(time.getHours()),
          minutes = padNumber(time.getMinutes());

      console.log(minutes);

      $scope.new_log = {
        sign_in: hours + ':' + minutes,
      };
    };

    $scope.updateLogs = function() {
      var tlog_entries = Restangular.all('transmitter_log_entries');

      tlog_entries.getList().then(function(tlogs) {
        $scope.tlogs = tlogs;
      });
    };

    $scope.signOut = function(tlog, update) {
      tlog.sign_out = tlog.time_out;
      console.log(tlog);

      var tlog_entry = Restangular.
        restangularizeElement(null, tlog, 'transmitter_log_entries');
      
      tlog_entry.put().then(function() {
        if (update) {
          $scope.updateLogs(update);
        } else {
          $scope.tlogs = _.without($scope.tlogs, tlog);
        }
      });
    };

    $scope.newLog = function(new_log) {
      var tlog_entries = Restangular.all('transmitter_log_entries');

      tlog_entries.post(new_log).then(function() {
        console.log("entry created ok");
        $scope.updateLogs();
      }, function() {
        console.log("error saving");
      });

    };

    resetLog();
    
  }
])

.directive('timePicker', function factory() {
  var directiveDef = {
    template: '<select></select>:<select></select>',
    restrict: 'E',
    scope: {
      time: '='
    },
    link: function (scope, element, attrs, controller) {
      var hour = angular.element(element.children()[0]),
          minute = angular.element(element.children()[1]),
          option;

      // add leading zero
      var padNumber = function(number) {
        return number < 10 ? '0' + number : number;
      };

      var updateTime = function() {
        scope.$apply(function(scope) {
          scope.time = hour.val() + ':' + minute.val();
        });
      };

      // Construct our hour and minute options, defaulting to current time.
      for (var i = 0; i < 24; i++) {
        option = angular.element('<option>').val(i).text(padNumber(i));
        hour.append(option);
      }

      for (var j = 0; j < 60; j++) {
        option = angular.element('<option>').val(j).text(padNumber(j));
        minute.append(option);
      }

      // Make sure the model is bound when we change the selectors.
      hour.bind('change', updateTime);
      minute.bind('change', updateTime);

      // Once model defaulted to current time, update the selectors.
      scope.$watch('time', function(newVal, oldVal) {
        if (newVal) {
          var hours_and_mins = newVal.split(':');
          hour.prop('selectedIndex', Number(hours_and_mins[0]));
          minute.prop('selectedIndex', Number(hours_and_mins[1]));  
        }
      });
    }    
  };

  return directiveDef;
});