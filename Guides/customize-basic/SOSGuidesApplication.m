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
 *  In the first example we we're doing a basic integration with no customization.
 *  Here we will be modifying the language presented to the user for various popups, and changing the look of the line drawing.
 */
- (void)setup {

  // First grab a pointer to the SOSSessionManager singleton.
  SOSSessionManager *sos = [SOSSessionManager sharedInstance];
  SOSUIComponents *components = [sos uiComponents];
  SOSScreenAnnotations *annotations = [sos annotations];

  [components setAlertTitle:@"Example 2."]; // Sets the title used for UI Alerts.
  [components setConnectMessage:@"This is the alert customers see when starting SOS"];
  [components setDisconnectMessage:@"This is the alert customers see when a user attempts to end a session"];
  [components setAgentDisconnectMessage:@"This is the alert customers see when the agent ends the session"];

  [components setConnectionRetryMessage:@"The user has been waiting in the queue, they will be asked to continue/quit here"];
  [components setConnectionTimedOutMessage:@"The session has gone unanswered too long, it has been automatically ended"];
  
  [annotations setLineWidth:18.f]; // this changes the width of the line drawn by the agent
  [annotations setLineColor:[UIColor magentaColor]]; // this changes the color of the line drawn by the agent
}

/**
 *  For this example we will also set the retry and expiry proprties of the options object.
 *  By default the user will be asked to retry every 30 seconds while waiting for an agent.
 *
 *  Sessions will also remain in the queue for 30 minutes unless an agent accepts, or the user cancels.
 */
- (SOSOptions *)getSessionOptions {

  NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
  NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];

  SOSOptions *opts = [SOSOptions optionsWithEmail:settings[@"Email"]
                                     liveAgentPod:settings[@"Live Agent Pod"]
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
  SOSSessionManager *sos = [SOSSessionManager sharedInstance];
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