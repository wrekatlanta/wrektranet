"use strict";

angular.module("wrektranet.airTransmitterLogCtrl", [])

.controller('airTransmitterLogCtrl', [
  '$scope',
  'Restangular',
  function($scope, Restangular) {
    Restangular.setBaseUrl('/air');

    var resetLog = function() {
      var time = new Date();

      $scope.new_log = {
        'sign_in': time.getHours() + ':' + Math.floor(time.getMinutes()/10)*10,
      };
    };

    $scope.updateLogs = function() {
      var tlog_entries = Restangular.all('transmitter_log_entries');
      tlog_entries.getList().then(function(tlogs) {
        $scope.tlogs = tlogs;
        console.log($scope.tlogs);
      });
    };

    $scope.signOut = function(tlog, time_out) {
      var tlog_entry = Restangular.
        restangularizeElement(null, tlog, 'transmitter_log_entries');
      tlog.sign_out = time_out;
      tlog_entry.put();
      console.log("sign_out", tlog);

    };

    $scope.newLog = function(new_log) {
      var combined_date = new_log.hour + new_log.minute;

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
      var hour = angular.element(element.children()[0]);
      var minute = angular.element(element.children()[1]);
      var current_time = new Date();

      var updateTime = function() {
        scope.$apply(function(scope) {
          scope.time = hour.val() + ':' + minute.val();
        });
      }

      // Construct our hour and minute options, defaulting to current time.
      for (var i = 0; i < 24; i++) {
        var option = angular.element('<option>').val(i).text(i);
        hour.append(option);

      };

      for (var j = 0; j < 6; j++) {
        var option = angular.element('<option>').val(j * 10).text(j * 10)
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
          minute.prop('selectedIndex', Number(hours_and_mins[1])/10);  
        }
      });
    }    
  };

  return directiveDef;
});