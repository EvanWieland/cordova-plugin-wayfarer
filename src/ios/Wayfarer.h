//
//  Wayfarer.h
//  Wayfarer
//
//  Created by Evan Wieland https://bitsmithy.io on 4/30/18.
//

#import <Cordova/CDV.h>

@interface Wayfarer : CDVPlugin

- (void)requestUpdates:(CDVInvokedUrlCommand*)command;
- (void)stopActivity:(CDVInvokedUrlCommand*)command;

@end