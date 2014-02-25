"use strict";

angular.module("wrektranet.airPlaylistCtrl", ['ui.router'])

.config([
  '$stateProvider',
  function($stateProvider) {
    $stateProvider
      .state('index', {
        templateUrl: 'index.html'
      })
      .state('search', {
        templateUrl: 'search.html'
      })
      .state('album', {
        templateUrl: 'album.html'
      })
      .state('album_error', {
        templateUrl: 'album_error.html'
      });
  }
])

.controller('airPlaylistCtrl', [
  '$scope',
  'Restangular',
  'promiseTracker',
  '$state',
  '$modal',
  '$window',
  function($scope, Restangular, promiseTracker, $state, $modal, $window) {
    /* This controller is a reimplementation
     * of the original live playlist's frequency logic.
     *
     * I didn't come up with the interval stuff.
     * - pstoic
     */

    Restangular.setBaseUrl('/air');

    $scope.tooltip_delay = 500;

    $scope.sources = ['CD1', 'CD2', 'CD3', 'TT1', 'TT2', 'Other'];
    $scope.current_source = $scope.sources[0];

    // map airplay frequency enum to replay intervals (by days)
    $scope.replay_intervals = {
      'H': 4,  // high
      'M': 7,  // medium
      'L': 10, // light
      'O': 35  // oldie
    };

    // a default interval, in days
    $scope.default_replay_interval = 14;

    $scope.play_logs = []; // contains recent logs
    $scope.queued_tracks = []; // contains tracks queued for logging
    $scope.album = null; // contains current selected album
    $scope.search = null; // contains search parameters

    $scope.playLogTracker = promiseTracker();
    $scope.loadingTracker = promiseTracker();

    // loads recently played tracks
    $scope.loadLogs = function() {
      var promise = Restangular
        .all('play_logs')
        .getList()
        .then(function(play_logs) {
          $scope.play_logs = play_logs;
        });

      $scope.playLogTracker.addPromise(promise);
    };

    // finds an album using given ID
    $scope.findAlbum = function(id) {
      var promise = Restangular
        .one('albums', id)
        .get()
        .then(function(album) {
          var airplay_frequency;
          $scope.album = album;
          
          airplay_frequency = $scope.replay_intervals[$scope.album.airplay_frequency];
          $scope.replay_interval = airplay_frequency || $scope.default_replay_interval;

          $state.go('album');
        }, function() {
          $state.go('album_error');
        });

      $scope.loadingTracker.addPromise(promise);
    };

    // searches for an album using the various form fields
    $scope.searchAlbum = function() {
      var promise = Restangular
        .all('albums')
        .getList($scope.search)
        .then(function(albums) {
          $scope.albums = albums;
          $state.go('search');
        });

      $scope.loadingTracker.addPromise(promise);
    };

    $scope.queueTrack = function(track) {
      track.album = $scope.album;
      track.source = $scope.current_source;
      if (!_.contains($scope.queued_tracks, track)) {
        $scope.queued_tracks.unshift(track);
      }
    };

    $scope.unqueueTrack = function(track) {
      $scope.queued_tracks = _.without($scope.queued_tracks, track);
    };

    $scope.playTrack = function(track) {
      var promise, restangularLog, play_log = {
        track_id: track.id
      };

      restangularLog = Restangular
        .restangularizeElement(null, play_log, 'play_logs');

      promise = restangularLog
        .post()
        .then(function(newLog) {
          $scope.unqueueTrack(track);

          newLog.read = false;
          newLog.track.source = track.source;
          $scope.play_logs.unshift(newLog);
        });

      $scope.playLogTracker.addPromise(promise);
    };

    $scope.removeLog = function(log) {
      var promise;

      if (confirm("Are you sure you want to delete this play?")) {
        promise = Restangular
          .one('play_logs', log.id)
          .remove()
          .then(function() {
            $scope.loadLogs();
          });

        $scope.playLogTracker.addPromise(promise);
      }
    };

    // resets forms and removes selected album and results
    $scope.reset = function() {
      $state.go('index');
      $scope.album = null;
      $scope.albums = null;
      $scope.album_id = null;

      $scope.search = {
        album_title: '',
        performance_by: '',
        org_name: ''
      };
    };

    $scope.openTimeModal = function(log) {
      var modalInstance = $modal.open({
        templateUrl: 'time_modal.html',
        controller: 'timeModalCtrl',
        resolve: {
          log: function () {
            return log;
          }
        }
      });

      modalInstance.result
        .then(function(reload) {
          if (reload) {
            $scope.loadLogs();
          }
        });
    };

    $scope.goToIndex = function() {
      $state.go('index');
    };

    // used for default text if the user hasn't searched for anything
    $scope.hasResults = function() {
      return $scope.album || $scope.albums;
    };

    $scope.belongsToUser = function(log, id) {
      return log.user.id && log.user.id === id;
    };

    /* the following can be extracted into a directive later on */
    // returns button class for play button according to replay interval logic
    $scope.playableButtonStatus = function(track) {
      var replay_interval, days, plays;

      if (track.in_rotation === 'O') {
        replay_interval = $scope.replay_intervals["O"];
      } else {
        replay_interval = $scope.replay_interval;
      }

      if (track.play_logs.length > 0) {
        plays = track.play_logs.length;
        days = track.play_logs[0].days_ago;

        if (plays > 0 && days < replay_interval) {
          return 'danger';
        } else if (days > replay_interval && days < 2 * replay_interval) {
          return 'warning';
        }
      }

      return 'success';
    };

    /* asks the user to confirm before leaving the page if there are unplayed tracks */
    $window.onbeforeunload = function() {
      if ($scope.queued_tracks.length > 0) {
        return 'You have tracks in your queue.';
      }
    };

    $scope.reset();
    $scope.loadLogs();
  }
])

.controller('timeModalCtrl', [
  '$scope',
  '$modalInstance',
  'promiseTracker',
  'log',
  'Restangular',
  function($scope, $modalInstance, promiseTracker, log, Restangular) {
    Restangular.setBaseUrl('/air');

    $scope.log = log;
    $scope.time_adjustment = 0;

    $scope.modalTracker = promiseTracker();

    $scope.previewTime = function(minutes) {
      var old_date = new Date(log.playtime),
          new_date = new Date(old_date);

      new_date.setMinutes(old_date.getMinutes() + minutes);

      return new_date;
    };

    $scope.close = function(reload) {
      $modalInstance.close(reload);
    };

    $scope.updateTime = function(minutes) {
      var promise = Restangular
        .one('play_logs', log.id)
        .customPOST({
          minutes: minutes,
        }, "adjust_time")
        .then(function() {
          $scope.close(true);
        });

      $scope.modalTracker.addPromise(promise);
    };
  }
]);