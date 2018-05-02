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
    /*if([CMMotionActivityManager isActivityAvailable]) {
        CMMotionActivityManager *cm = [[CMMotionActivityManager alloc] init];
        CMStepCounter *sc = [[CMStepCounter alloc] init];
        NSDate *today = [NSDate date];
        NSDate *lastWeek = [today dateByAddingTimeInterval:-(86400*7)];
        [cm queryActivityStartingFromDate:lastWeek toDate:today toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray *activities, NSError *error){
            for(int i=0;i<[activities count]-1;i++) {
                CMMotionActivity *a = [activities objectAtIndex:i];
                NSString *confidence = @"low";
                if (a.confidence == CMMotionActivityConfidenceMedium) confidence = @"medium";
                if (a.confidence == CMMotionActivityConfidenceHigh) confidence = @"high";
                NSString *motion = @"";
                if (a.stationary) motion = [motion stringByAppendingString:@"stationary "];
                if (a.walking) motion = [motion stringByAppendingString:@"walking "];
                if (a.running) motion = [motion stringByAppendingString:@"running "];
                if (a.automotive) motion = [motion stringByAppendingString:@"automotive "];
                // Now get steps as well
                [sc queryStepCountStartingFrom:a.startDate to:[[activities objectAtIndex:i+1] startDate] toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
                    NSLog(@"%@ confidence %@ type %@ steps %ld", [NSDateFormatter localizedStringFromDate:a.startDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle], confidence, motion, numberOfSteps);
                }];
            }
        }];
    }*/


    BOOL isActivityAvailable =  [CMMotionActivityManager isActivityAvailable];

    NSLog(@"isActivityAvailable %d", isActivityAvailable);

    if(isActivityAvailable)
    {
        _motionActivityManager = [[CMMotionActivityManager alloc] init];
        CMStepCounter *sc = [[CMStepCounter alloc] init];

        [self.commandDelegate runInBackground:^{
            [_motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {

                /*NSLog(@"Got a core motion update");
                NSLog(@"Current activity date is %f",activity.timestamp);
                NSLog(@"Current activity confidence from a scale of 0 to 2 - 2 being best- is: %ld", (long)activity.confidence);
                NSLog(@"Current activity type is unknown: %i",activity.unknown);
                NSLog(@"Current activity type is stationary: %i",activity.stationary);
                NSLog(@"Current activity type is walking: %i",activity.walking);
                NSLog(@"Current activity type is running: %i",activity.running);
                NSLog(@"Current activity type is cycling: %i",activity.cycling);
                NSLog(@"Current activity type is automotive: %i",activity.automotive);*/

                NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
                [jsonObj setValue: [NSString stringWithFormat:@"%ld", activity.confidence] forKey:@"confidence"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.unknown] forKey:@"unknown"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.stationary] forKey:@"stationary"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.walking] forKey:@"walking"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.running] forKey:@"running"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.cycling] forKey:@"cycling"];
                [jsonObj setValue: [NSString stringWithFormat:@"%d", activity.automotive] forKey:@"automotive"];

                /*NSString *confidence = @"low";
                if (activity.confidence == CMMotionActivityConfidenceMedium) confidence = @"medium";
                if (activity.confidence == CMMotionActivityConfidenceHigh) confidence = @"high";
                NSString *motion = @"";
                if (activity.stationary) motion = [motion stringByAppendingString:@"stationary"];
                if (activity.walking) motion = [motion stringByAppendingString:@"walking"];
                if (activity.running) motion = [motion stringByAppendingString:@"running"];
                if (activity.automotive) motion = [motion stringByAppendingString:@"automotive"];
                // Now get steps as well
                [sc startStepCountingUpdatesToQueue:[NSOperationQueue new] updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error)
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         NSLog(@"numberOfSteps %ld", (long)numberOfSteps);
                     }];
                }];*/


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