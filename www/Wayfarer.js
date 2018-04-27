
module.exports = (function () {
    "use strict";
                  
    var ngmotion = {},
        successCallBack = null,
        failCallBack = null,
        motionTypeNotMoving = 1,
        motionTypeWalking = 2,
        motionTypeRunning = 3,
        motionTypeDriving = 4,
        minimumSpeed = 0.3,
        walkingSpeed = 1.9,
        runningSpeed = 7.5,
        drivingSpeed = 25.0,
        isShaking = false,
        previousAcceleration = { x: null, y: null, z: null },
        locationWatchID = null,
        accelerationWatchID = null,
        frequence = 3000;

    // Start watching the motion gesture
    ngmotion.startWatch = function (onSuccess, onFail, _walkingSpeed, _runningSpeed, _drivingSpeed, _frequence) {
        if (onSuccess) {
            successCallBack = onSuccess;
        }
                  
        if (onFail) {
            failCallBack = onFail;
        }
        
        if (typeof _frequence === "number") {
            frequence = _frequence;
        }
        
        if (typeof _walkingSpeed === "number") {
            walkingSpeed = _walkingSpeed;
        }
           
        if (typeof _runningSpeed === "number") {
            runningSpeed = _runningSpeed;
        }
        
        if (typeof _drivingSpeed === "number") {
            drivingSpeed = _drivingSpeed;
        }
        
        accelerationWatchID = navigator.accelerometer.watchAcceleration(onFetchAccelerationSuccess, null, {frequency: 300});
        locationWatchID = navigator.geolocation.watchPosition(onFetchLocationSuccess, onFetchLocationError,  {frequency: frequence});
    };

    // Stop watching the motion gesture
    ngmotion.stopWatch = function () {
        if (accelerationWatchID !== null) {
            navigator.accelerometer.clearWatch(accelerationWatchID);
            accelerationWatchID = null;
        }
                  
        if (locationWatchID !== null) {
            navigator.geolocation.clearWatch(locationWatchID);
            locationWatchID = null;
        }
    };
                  
    function onFetchAccelerationSuccess(acceleration) {
        var accelerationChange = {};
                  
        if (previousAcceleration.x !== null) {
            accelerationChange.x = Math.abs(previousAcceleration.x - acceleration.x);
            accelerationChange.y = Math.abs(previousAcceleration.y - acceleration.y);
            accelerationChange.z = Math.abs(previousAcceleration.z - acceleration.z);
        }
                  
        if (accelerationChange.x + accelerationChange.y + accelerationChange.z > 30)
            isShaking = true;
        else
            isShaking = false;
                  
        previousAcceleration = {
            x: acceleration.x,
            y: acceleration.y,
            z: acceleration.z
        };
    };
                  
    function onFetchLocationSuccess(position) {
        console.log('Latitude: '  + position.coords.latitude          + '\n' +
                    'Longitude: '         + position.coords.longitude         + '\n' +
                    'Altitude: '          + position.coords.altitude          + '\n' +
                    'Accuracy: '          + position.coords.accuracy          + '\n' +
                    'Altitude Accuracy: ' + position.coords.altitudeAccuracy  + '\n' +
                    'Heading: '           + position.coords.heading           + '\n' +
                    'Speed: '             + position.coords.speed             + '\n' +
                    'Timestamp: '         + position.timestamp                + '\n');
                  
        var heading = 0;
        var speed = 0;
        var motionType = 0;
                  
        if (position.coords.heading != null)
            heading = position.coords.heading;
                  
        if (position.coords.speed != null)
            speed = position.coords.speed;
                  
        if (speed < minimumSpeed)
            motionType = motionTypeNotMoving;
        else if (speed <= walkingSpeed)
            motionType = ((isShaking == true) ? motionTypeRunning : motionTypeWalking);
        else if (speed <= runningSpeed)
            motionType = ((isShaking == true) ? motionTypeRunning : motionTypeDriving);
        else
            motionType = motionTypeDriving;
                  
        console.log("head:" + heading + "speed:" + speed + "latitude:" + position.coords.latitude + "longitude:" + position.coords.longitude + "motionType:" + motionType);
   
        if (typeof successCallBack === "function") {
            successCallBack(heading, speed, position.coords.latitude, position.coords.longitude, motionType);
        }
    }
                  
    function onFetchLocationError(error) {
        if (typeof failCallBack === "function") {
            failCallBack(error);
        }
    }
    
    return ngmotion;
})();
