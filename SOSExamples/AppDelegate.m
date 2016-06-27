/*
 * Copyright © salesforce.com, inc. 2014-2016
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, this
 * list of conditions and the following disclaimer in the documentation and/or
 * other materials provided with the distribution.
 *
 * Neither the name of salesforce.com nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

#import <SOS/SOS.h>
#import <SOS/SOSError.h>

@interface AppDelegate() <SOSDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[[SCServiceCloud sharedInstance] sos] addDelegate:self];

    return YES;
}

// All errors will come through this method. You can log them or ignore them. If you only wish to handle fatal errors you can use
// [SOSDelegate sos:didStopWithReason:error:].
- (void)sos:(SOSSessionManager *)sos didError:(NSError *)error {
    NSLog(@"Logged an error: %@", error);
}

// You can check for fatal errors with this delegate method. Any error which results in [SOSDelegate sos:didStopWithReason:error:] being
// executed is considered fatal.
- (void)sos:(SOSSessionManager *)sos didStopWithReason:(SOSStopReason)reason error:(NSError *)error {
    NSString *description = [error localizedDescription];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *configuredViewControllers = settings[@"Custom ViewControllers"];

    // You can determine the type of error by looking at the error code, and comparing it to the enum present in SOSError.h
    NSUInteger errorCode = [error code];
    NSLog(@"Something went wrong: %@, SOSError code: %lu", description, (unsigned long)errorCode);

    // You can do conditional error messages based on the type of error. Here we'll handle the No Agents Available error and display a custom message
    switch (errorCode) {
        case SOSNoAgentsAvailableError: {
            description = @"Hey it looks like there are no agents available. Please try again later!";
            break;
        }
        default: {
            break;
        }
    }

    if ([configuredViewControllers[@"Errors"] boolValue]) {
        // Use a custom class to handle alerts.
        SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
        [alertView showError:@"Something went wrong!" subTitle:description closeButtonTitle:@"Dismiss" duration:0.0f];

    } else {
        // Use generic alert controller
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SOS" message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
