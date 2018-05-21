var exec = require('cordova/exec');

var Wayfarer = function () {
    this.subscribe = function (scb, ecb) {
        if (Wayfarer.prototype._os() === 'Android') {
            Wayfarer.prototype._android._subscribe(scb, ecb);
        } else if (Wayfarer.prototype._os() === 'iOS') {
            Wayfarer.prototype._ios._subscribe(scb, ecb);
        }
    };

    this.unsubscribe = function (scb, ecb) {
        if (Wayfarer.prototype._os() === 'Android') {
            Wayfarer.prototype._android._unsubscribe(scb, ecb);
        } else if (Wayfarer.prototype._os() === 'iOS') {
            Wayfarer.prototype._ios._unsubscribe(scb, ecb);
        }
    };

    this.hasPermission = function (scb, ecb) {
        if (Wayfarer.prototype._os() === 'Android') {
            Wayfarer.prototype._android._hasPermission(scb);
        } else if (Wayfarer.prototype._os() === 'iOS') {
            Wayfarer.prototype._ios._hasPermission(scb, ecb);
        }
    };
};

Wayfarer.prototype = {
    _os             : function () {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;
        var res       = 'unknown';
        // Windows Phone must come first because its UA also contains "Android"
        if (/windows phone/i.test(userAgent)) {
            res = 'Windows Phone';
        }

        if (/android/i.test(userAgent)) {
            res = 'Android';
        }

        // iOS detection from: http://stackoverflow.com/a/9039885/177710
        if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
            res = 'iOS';
        }

        return res;
    },
    _universalResult: function (activityData) {
        var activity   = 'unknown';
        var confidence = 0;

        if (Number(activityData.automotive) || activityData.ActivityType === 'IN_VEHICLE') {
            activity = 'automotive';
        }
        if (Number(activityData.cycling) || activityData.ActivityType === 'ON_BICYCLE') {
            activity = 'cycling';
        }
        if (Number(activityData.running) || activityData.ActivityType === 'RUNNING') {
            activity = 'running';
        }
        if (Number(activityData.walking) || activityData.ActivityType === 'ON_FOOT') {
            activity = 'walking';
        }
        if (Number(activityData.stationary) || activityData.ActivityType === 'STILL') {
            activity = 'stationary';
        }
        if (activityData.ActivityType === 'TILTING') {
            activity = 'tilting';
        }

        if (activityData.Probability) {
            confidence = activityData.Probability;
        }

        if (activityData.confidence) {
            // Raise to a percentage
            confidence = (activityData.confidence * 50);
        }

        return {
            activity  : activity,
            confidence: confidence
        };
    },
    // =====

    _android: {
        _getActivity         : function (success, error) {
            exec(success, error, 'Wayfarer', 'GetActivity', []);
        },
        _connect             : function (success, error) {
            exec(success, error, 'Wayfarer', 'Connect', []);
        },
        _disconnect          : function (success, error) {
            exec(success, error, 'Wayfarer', 'Disconnect', []);
        },
        _startActivityUpdates: function (interval, success, error) {
            exec(success, error, 'Wayfarer', 'StartActivityUpdates',
                [interval]);
        },
        _stopActivityUpdates : function (success, error) {
            exec(success, error, 'Wayfarer', 'StopActivityUpdates', []);
        },
        _destroy             : function (success, error) {
            exec(success, error, 'Wayfarer', 'Destroy', []);
        },
        _subscribe           : function (successCB, errorCB) {
            Wayfarer.prototype._android._connect(
                function success() {
                    Wayfarer.prototype._android._startActivityUpdates(
                        15e3,
                        function success() {
                            setInterval(function () {
                                Wayfarer.prototype._android._getActivity(
                                    function success(result) {
                                        if (successCB) successCB(Wayfarer.prototype._universalResult(result));
                                    },
                                    function fail(error) {
                                        if (errorCB) errorCB(error);
                                    }
                                );
                            }, 15e3);
                        },
                        function fail(error) {
                            if (errorCB) errorCB(error);
                        }
                    );
                },
                function fail(error) {
                    if (errorCB) errorCB(error);
                }
            );
        },
        _unsubscribe         : function (successCB, errorCB) {

        },
        _hasPermission       : function (successCB) {
            if (!successCB) {
                successCB = function () {
                };
            }

            // Android will always have permission?
            successCB(true);
        },
    },

    _ios: {
        _requestUpdates: function (success, error) {
            if (!success) {
                success = function () {
                };
            }

            if (!error) {
                error = function () {
                };
            }

            exec(success, error, 'Wayfarer', 'requestUpdates', []);
        },
        _unsubscribe   : function (success, error) {
            if (!success) {
                success = function () {
                };
            }

            if (!error) {
                error = function () {
                };
            }
            exec(success, error, 'Wayfarer', 'stopActivity', []);
        },
        _subscribe     : function (successCB, errorCB) {
            Wayfarer.prototype._ios._requestUpdates(
                function success(result) {
                    if (successCB) successCB(Wayfarer.prototype._universalResult(result));
                },
                function fail(error) {
                    if (errorCB) errorCB(error);
                }
            );
        },
        _hasPermission : function (success, error) {
            if (!success) {
                success = function () {
                };
            }
            if (!error) {
                error = function () {
                };
            }
            exec(success, error, 'Wayfarer', 'hasPermission', []);
        }
    }
};

module.exports = new Wayfarer();