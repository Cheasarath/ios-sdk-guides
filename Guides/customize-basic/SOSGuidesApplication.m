/*
 * Copyright (c) 2014, GoInstant Inc., a salesforce.com company
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
 * Neither the name of the {organization} nor the names of its
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
#import <SOS/SOS.h>
#import "SOSGuidesApplication.h"

@interface SOSBranding (override)
+ (UIColor *)brandPrimaryWithAlpha:(CGFloat)alpha;
+ (UIColor *)brandSecondaryWithAlpha:(CGFloat)alpha;
+ (UIColor *)tertiaryWithAlpha:(CGFloat)alpha;
+ (UIColor *)quaternaryWithAlpha:(CGFloat)alpha;
+ (UIColor *)textPrimaryWithAlpha:(CGFloat)alpha;
+ (UIColor *)textSecondaryWithAlpha:(CGFloat)alpha;
+ (UIColor *)feedbackWithAlpha:(CGFloat)alpha;
+ (UIColor *)background;
+ (UIColor *)header;
+ (UIColor *)headline;
+ (UIColor *)active;
+ (UIColor *)inactive;
+ (UIColor *)cta;
+ (UIColor *)title;
@end

@implementation SOSBranding (override)

+ (UIColor *)brandPrimaryWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:46.f/255.f green:189.f/255.f blue:89.f/255.f alpha:alpha];
    return color;
}

+ (UIColor *)brandSecondaryWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:39.f/255.f green:163.f/255.f blue:76.f/255.f alpha:alpha];
    return color;
}

+ (UIColor *)tertiaryWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:alpha];
    return color;
}

// Not used.
+ (UIColor *)quaternaryWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:68.f/255.f green:68.f/255.f blue:68.f/255.f alpha:alpha];
    return color;
}

+ (UIColor *)textPrimaryWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:alpha];
    return color;
}

+ (UIColor *)textSecondaryWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:alpha];
    return color;
}

+ (UIColor *)feedbackWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:alpha];
    return color;
}

+ (UIColor *)background {
    UIColor *color = [UIColor colorWithRed:17.f/255.f green:17.f/255.f blue:17.f/255.f alpha:1.0f];
    return color;
}

+ (UIColor *)header {
    UIColor *color = [UIColor colorWithRed:34.f/255.f green:34.f/255.f blue:34.f/255.f alpha:1.0f];
    return color;
}

+ (UIColor *)headline {
    UIColor *color = [UIColor whiteColor];
    return color;
}

// Not used.
+ (UIColor *)active {
    UIColor *color = [UIColor colorWithRed:78/255.f green:216/255.f blue:102/255.f alpha:1.f];
    return color;
}

// Not used.
+ (UIColor *)inactive {
    UIColor *color = [UIColor colorWithRed:248/255.f green:231/255.f blue:28/255.f alpha:1.f];
    return color;
}

+ (UIColor *)cta {
    UIColor *color = [UIColor colorWithRed:252/255.f green:252/255.f blue:252/255.f alpha:1.f];
    return color;
}

+ (UIColor *)title {
    UIColor *color = [UIColor colorWithRed:251/255.f green:251/255.f blue:251/255.f alpha:1.f];
    return color;
}
@end

@interface SOSGuidesApplication() <SOSDelegate> {
}
@end

/**
 *  In this guide we will be customizing some of the default SOS behavior.
 *
 *  As the name of the guide suggests this is basic customization restricted to setting a few properties.
 *  The SOSUIComponents class provides access to toggle/customize most UI behavior.
 *  The SOSScreenAnnotations class provides the ability to modify properties related to line drawing.
 *
 */
@implementation SOSGuidesApplication

/**
 *  For this example we will also set the retry and expiry proprties of the options object.
 *  By default the user will be asked to retry every 30 seconds while waiting for an agent.
 *
 *  Sessions will also remain in the queue for 30 minutes unless an agent accepts, or the user cancels.
 */
- (SOSOptions *)getSessionOptions {

  NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
  NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];

  SOSOptions *opts = [SOSOptions optionsWithLiveAgentPod:settings[@"Live Agent Pod"]
                                                   orgId:settings[@"Salesforce Organization ID"]
                                            deploymentId:settings[@"Deployment ID"]];

  [opts setSessionRetryTime:10 * 1000]; // Set the retry prompt for 10 seconds (10,000 ms)

  return opts;
}

/**
 * In the previous example, everytime we pressed an SOS button it would attempt to start a new session.
 * If you try to start a session while a session is active/connecting this would return an error.
 * In most cases it's safe to ignore this error, but our first example just tossed an alert to the user.
 *
 * Instead; let's add a check for the session state, and then prompt the user to cancel the session.
 */
- (void)startSession {
    SOSSessionManager *sos = [[SCServiceCloud sharedInstance] sos];
    if ([sos state] != SOSSessionStateInactive) {
        // We're either connecting, or are in a session already.

        // Calling stopSession will prompt the user to cancel the session. If they cancel, this method does nothing.
        // Otherwise it will begin the shutdown flow.
        [sos stopSession];
        return;
    }

    SOSOptions *opts = [self getSessionOptions];
    [sos startSessionWithOptions:opts completion:^(NSError *error, SOSSessionManager *sos) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];

            [alert show];
        }
    }];
}

#pragma mark - Singleton

+ (instancetype)sharedInstance {
  static id instance;
  static dispatch_once_t once;

  dispatch_once(&once, ^{
    instance = [[self alloc] init];
  });

  return instance;
}

@end