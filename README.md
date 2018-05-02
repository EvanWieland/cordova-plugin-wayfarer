# 🌊⛵🌊 Cordova Wayfarer Plugin
Cordova plugin for determining activity based on device motion.

## Purpose

Wayfarer predicts the current activity a user is engaged in by analayzing the device's motion and geolocation.

## Installation

    cordova plugin add cordova-plugin-wayfarer

## Supported Platforms

- Android
- iOS
    
## Properties

- Wayfarer.subscribe
- Wayfarer.unsubscribe [not complete]

### Example

```js
Wayfarer.subscribe(
    function(activityData){
        // activityData returns: 
        // {
        // activity: 'AUTOMOTIVE', 
        // confidence: '39%'
        // }
    },
    function(error){
        console.error(error); // Returns error
    }
);

Wayfarer.unsubscribe(
    function(){},
    function(error){
        console.error(error); // Returns error
    }
);
```

## Credits

### Android

Credits to [@polybuildr](https://github.com/polybuildr/cordova-plugin-activity-recognition) for much of the Android code.

### iOS

Credits to [@mrameezraja](https://github.com/mrameezraja/cordova-plugin-motion-activity) for much of the iOS code.

## Disclaimer

The Cordova Wayfarer Plugin is in its infant stages. The `subscribe` method is production ready, but there isn't even a 
way to unsubscribe from events yet. Also, I am not fluent in Objective-C or Java, so you will see some ugly code. 
If you would like, give me a hand and help clean it up!