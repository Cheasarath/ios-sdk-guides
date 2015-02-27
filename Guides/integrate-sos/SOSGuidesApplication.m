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
 *  In this guide you'll be setting up a basic implementation of SOS in our demo application.
 *
 *  There are a few things to note.
 *  1. The majority of the application specific code will be common for all guides in this project.
 *     You can find that code in the 'Common' group.
 *  2. This class will be implemented separately for each guide (Target), but each guide builds on the
 *     previous one so code will be moved, and in one place.
 *  3. New code for each guide will be commented.
 */
@implementation SOSGuidesApplication

/**
 *  This method is called from application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions in the SOSExamples/AppDelegate.m file.
 *  For our basic integration there's nothing to do here.
 *
 *  We will be adding more to this as we go.
 */
- (void)setup {
}

/**
 *  Simple class method which wraps starting an SOS session. Although SOSSessionManager is a singleton, there is some boilerplate code for starting
 *  a session that you would have to repeat for any action which would trigger a session.
 */
- (void)startSession {

  SOSOptions *opts = [self getSessionOptions];
  [[SOSSessionManager sharedInstance] startSessionWithOptions:opts completion:^(NSError *error, SOSSessionManager *sos) {

    // Simple error handling case.
    // If any part of a session launch returns an error it will be available here.
    // If you haven't changed the Account/Application names for example you will see an error here.
    if (error) {

      // Generate an alert
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

      // Show the error.
      [alert show];
    }
  }];
}


/**
 *  Simple way to generate an SOSOptions object to be consumed by a session.
 *  In our simple case we will grab this information from the SOSSettings.plist
 *
 *  @return an SOSOptions instance to be consumed by an SOS Session.
 */
- (SOSOptions *)getSessionOptions {

  NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
  NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];

  // NOTE: By default the valies in the SOSSettings.plist are not valid and will result in an error on session start.
  // Be sure to change those to match the credentials provided to you.
  return [SOSOptions optionsWithEmail:settings[@"Email"]
                         liveAgentPod:settings[@"Live Agent Pod"]
                                orgId:settings[@"Salesforce Organization ID"]
                         deploymentId:settings[@"Deployment ID"]];
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
