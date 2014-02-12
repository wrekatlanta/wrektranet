"use strict";

angular.module("wrektranet.airPlaylistCtrl", ['ui.router'])

.config([
  '$stateProvider',
  function($stateProvider) {
    $stateProvider
      .state('index', {
        templateUrl: 'index.html'
      })
      .state('track_queued', {
        templateUrl: 'track_queued.html'
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
  function($scope, Restangular, promiseTracker, $state) {
    /* This controller is a reimplementation
     * of the original live playlist's frequency logic.
     *
     * I didn't come up with the interval stuff.
     * - pstoic
     */

    Restangular.setBaseUrl('/air');

    // map airplay frequency enum to replay intervals (by days)
    $scope.replay_intervals = {
      'H': 4,  // high
      'M': 7,  // medium
      'L': 10, // light
      'O': 35  // oldie
    };

    // a default interval
    $scope.default_replay_interval = 14;

    $scope.play_logs = []; // contains recent logs
    $scope.queued_tracks = []; // contains tracks queued for logging
    $scope.album = null; // contains current selected album
    $scope.search = null; // contains search parameters

    $scope.playLogTracker = promiseTracker.register('playLogTracker');
    $scope.loadingTracker = promiseTracker.register('loadingTracker');

    // loads recently played tracks
    $scope.loadLogs = function() {
      var promise = Restangular
        .all('play_logs')
        .getList()
        .then(function(play_logs) {
          $scope.play_logs = play_logs;
        });

      $scope.play_logs = [];

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
      $scope.queued_tracks.unshift(track);

      $state.go('track_queued');
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
          $scope.play_logs.unshift(newLog);
        });

      $scope.playLogTracker.addPromise(promise);
    };

    $scope.removeLog = function(log) {
      var promise;

      console.log(log);

      promise = Restangular
        .one('play_logs', log.id)
        .remove()
        .then(function() {
          $scope.play_logs = _.without($scope.play_logs, log);
        });

      $scope.playLogTracker.addPromise(promise);
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

    // used for default text if the user hasn't searched for anything
    $scope.hasResults = function() {
      return $scope.album || $scope.albums;
    };

    /* the following can be extracted into a directive later on */
    // returns button class for play button according to replay interval logic
    $scope.playableButtonStatus = function(track) {
      var replay_interval, days;

      if (track.in_rotation === 'O') {
        replay_interval = $scope.replay_intervals["O"];
      } else {
        replay_interval = $scope.replay_interval;
      }

      if (track.play_logs.length > 0) {
        days = track.play_logs[0].days_ago;

        if (days !== 0 && days < replay_interval) {
          return 'danger';
        } else if (days > replay_interval && days < 2 * replay_interval) {
          return 'warning';
        }
      }

      return 'success';
    };

    $scope.reset();
    $scope.loadLogs();
  }
])

.controller(function() {

});