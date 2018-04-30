# 🌊⛵🌊 Cordova Wayfarer Plugin [Under Construction]
Cordova plugin for determining activity based on device motion.

## Purpose

Wayfarer predicts the current activity a user is engaged in by analayzing the device's motion and geolocation.

## Installation

    cordova plugin add cordova-plugin-wayfarer

## Supported Platforms

- Android
- iOS
    
## Properties

- Wayfarer.foo

### Example

```js
Wayfarer.foo(
    function(traffic){
        // traffic returns: 
        // {
        // receivedBytes: 103424, 
        // transmittedBytes: 6144, 
        // totalBytes: 109568
        // }
    },
    function(error){
        console.error(error); // Returns error
    }
);
```
