//
//  Wayfarer.m
//  Wayfarer
//
//  Created by Evan Wieland https://bitsmithy.io on 4/30/18.
//

#import "Wayfarer.h"

#import <Foundation/Foundation.h>
#import "Wayfarer.h"
#import <CoreMotion/CoreMotion.h>


@interface Wayfarer ()

    @property (nonatomic, retain) CMMotionActivityManager* motionActivityManager;

@end

@implementation Wayfarer

- (void)requestUpdates:(CDVInvokedUrlCommand*)command
{
    NSLog(@"requestUpdates");

    BOOL isActivityAvailable =  [CMMotionActivityManager isActivityAvailable];

    NSLog(@"isActivityAvailable %d", isActivityAvailable);

    if(isActivityAvailable)
    {
        _motionActivityManager = [[CMMotionActivityManager alloc] init];
        CMStepCounter *sc = [[CMStepCounter alloc] init];

        [self.commandDelegate runInBackground:^{
            [_motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
                NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
                [jsonObj setValue: [NSString stringWithFormat:@"%ld", activity.confidence] forKey:@"confidence"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.unknown] forKey:@"unknown"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.stationary] forKey:@"stationary"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.walking] forKey:@"walking"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.running] forKey:@"running"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.cycling] forKey:@"cycling"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.automotive] forKey:@"automotive"];


                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
                [result setKeepCallbackAsBool:1];

                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }];
        }];
    }
    else
    {
        NSLog(@"CMMotionActivityManager is not available");
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CMMotionActivityManager is not available"] callbackId:command.callbackId];
    }
}

- (void)stopActivity:(CDVInvokedUrlCommand*)command
{
    NSLog(@"stopActivity");

    BOOL isActivityAvailable =  [CMMotionActivityManager isActivityAvailable];

    if(isActivityAvailable){
        [_motionActivityManager stopActivityUpdates];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"stopped"] callbackId:command.callbackId];
    }
    else
    {
        NSLog(@"CMMotionActivityManager is not available");
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CMMotionActivityManager is not available"] callbackId:command.callbackId];
    }
}

@end