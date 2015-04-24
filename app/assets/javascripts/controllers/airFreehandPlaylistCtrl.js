"use strict";

angular.module("wrektranet.airFreehandPlaylistCtrl", ['ui.router'])
.config([
    '$stateProvider',
    function($stateProvider) {
        $stateProvider
            .state('index.freehand', {
                templateUrl: 'welcome.html'
            });
    }
])

.controller('airFreehandPlaylistCtrl', [
    '$scope',
    'Restangular',
    'promiseTracker',
    '$state',
    '$modal',
    '$window',
    '$log',
    function($scope, Restangular, promiseTracker, $state, $modal, $window, $log) {
        Restangular.setBaseUrl('/air');

        $scope.tooltip_delay = 500;



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
                .all('freehand_play_logs')
                .getList()
                .then(function(play_logs) {
                    $scope.play_logs = play_logs;
                });

            $scope.playLogTracker.addPromise(promise);
        };


        $scope.queueTrack = function(track) {
            if (!_.contains($scope.queued_tracks, track)) {
                $scope.queued_tracks.unshift(track);
            }
            $scope.reset();

        };

        $scope.unqueueTrack = function(track) {
            $scope.queued_tracks = _.without($scope.queued_tracks, track);
        };

        $scope.playTrack = function(track) {
            var promise, restangularLog, play_log = {
                performance_by: track.performance_by,
                album_title: track.album_title,
                track_title: track.track_title,
                side: track.side,
                track: track.track_number,
                label: track.org_name,
                show_id: track.show_id,
            };

            restangularLog = Restangular
                .restangularizeElement(null, play_log, 'freehand_play_logs');

            $log.debug(restangularLog);
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

            if (confirm("Are you sure you want to delete this play?")) {
                promise = Restangular
                    .one('freehand_play_logs', log.id)
                    .remove()
                    .then(function() {
                        $scope.loadLogs();
                    });

                $scope.playLogTracker.addPromise(promise);
            }
        };

        // resets forms and removes selected album and results
        $scope.reset = function() {
            $state.go('index.freehand');

            $scope.track = {
                performance_by: '',
                track_title: '',
                album_title: '',
                org_name: '',
                track_number: '',
                format_id:'12'
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
            $state.go('index.freehand');
        };


        $scope.belongsToUser = function(log, id) {
            return true;
            //return log.user.id && log.user.id === id;
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
                .one('freehand_play_logs', log.id)
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