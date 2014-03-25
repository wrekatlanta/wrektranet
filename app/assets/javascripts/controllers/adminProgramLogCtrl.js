"use strict";

angular.module("wrektranet.adminProgramLogCtrl", [])

.controller('adminProgramLogCtrl', [
  '$scope',
  function($scope) {
    var padNumber = function(number) {
      return number < 10 ? '0' + number : number;
    };

    $scope.repeatIntervals = [
      { minutes: 0,   label: "Don't repeat" },
      { minutes: 15,  label: "15 minutes" },
      { minutes: 30,  label: "30 minutes" },
      { minutes: 45,  label: "45 minutes" },
      { minutes: 60,  label: "1 hour" },
      { minutes: 90,  label: "1.5 hours" },
      { minutes: 120, label: "2 hours" },
      { minutes: 180, label: "3 hours" }
    ];

    $scope.resetNewSchedule = function() {
      $scope.newSchedule = {
        sunday:          false,
        monday:          false,
        tuesday:         false,
        wednesday:       false,
        thursday:        false,
        friday:          false,
        saturday:        false,
        start_date:      null,
        expiration_date: null,
        start_time:      null,
        end_time:        null,
        repeat_interval: $scope.repeatIntervals[0].minutes
      };
    }

    $scope.addSchedule = function(event) {
      var schedule = angular.copy($scope.newSchedule);
      event.preventDefault();

      if ($scope.plogForm.startTime.$invalid) {
        return false;
      }

      $scope.program_log_entry.program_log_schedules.push(schedule);
      $scope.resetNewSchedule();
    };

    $scope.deleteSchedule = function(schedule) {
      if (schedule.id) {
        // set destroy flag to true
        schedule.destroy = 1;
      } else {
        // unsaved Schedule, remove it entirely
        $scope.program_log_entry.program_log_schedules.splice($.inArray(schedule, $scope.program_log_entry.program_log_schedules), 1);
      }
    };

    $scope.timeOfDay = function(time) {
      if (_.has(time, 'hour')) {
        return padNumber(time.hour) + ":" + padNumber(time.minute);
      } else {
        return time;
      }
    }

    // set $scope.newSchedule with initial values
    $scope.resetNewSchedule();
  }
]);