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

#import "SOSExampleAlert.h"
#import "SOSExampleNotification.h"

@interface MyContainerWindow : UIWindow
@end

@interface MyAlert: NSObject<SOSAlertNotification>
@property SOSExampleAlert *alert;
@property MyContainerWindow *window;
@property (copy) void (^blockInternal)(BOOL);
@end

@implementation MyContainerWindow

// This is a work around to allow an 'invisible' view to provide touch events to subviews.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  __block UIView *hit = nil;

  [[self subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    CGPoint transPoint = [self convertPoint:point toView:view];
    hit = [view hitTest:transPoint withEvent:event];
    *stop = (hit != nil);
  }];

  return hit;
}

@end

@interface SOSGuidesApplication() <SOSDelegate> {
  MyContainerWindow *_container;
  SOSExampleAlert *_alert;
  SOSExampleNotification *_notification;
  MyAlert *_myAlert;

}
@end

/**
 *  In the previous guide we changed some UI properties to customize some of the SOS experience for the application.
 *
 *  In this guide we'll be disabling most of the default UI which SOS provides, and we will customize the general behavior of SOS.
 */
@implementation SOSGuidesApplication

#pragma mark - New Code

/**
 * To fully customize the look and feel of SOS, we need to diable and replace the default UI behavior provided by the framework.
 * We will do this in several steps:
 *  1. Gestures and ProgressHUD. This means that there will be no UI prompts from the framework. UIAlerts will still continue to fire.
 *  2. Replace the progress hud, with a notification bar which allows the user to continue using their app, but with updates about
 *     The current status of the session.
 */
- (void)setup {

  _myAlert = [MyAlert new];

  // First grab a pointer to the SOSSessionManager singleton.
  SOSSessionManager *sos = [SOSSessionManager sharedInstance];
  SOSUIComponents *components = [sos uiComponents];

  /**
   * Here the components alert delegate is changed to "_myAlert". One of the properties of _myAlert is the class containing the custom
   * alert (example custom alert available in SOSExampleAlert.m). When an alert is triggered, we can then decide to use a custom alert
   * or the standard alert. This is shown below inside the implementation of MyAlert.
   */
  [components setAlertDelegate: _myAlert];

  // Step 1. Disable default SOS UI behavior. NOTE: This does not extend to the agent window displayed during a session.
  [components setProgressHudEnabled:NO]; // The progress hud will no longer be displayed.

  [components setAlertTitle:@"Example 3."]; // Sets the title used for UI Alerts.
  [components setConnectMessage:@"This is the alert customers see when starting SOS"];
  [components setDisconnectMessage:@"This is the alert customers see when a user attempts to end a session"];
  [components setAgentDisconnectMessage:@"This is the alert customers see when the agent ends the session"];

  [components setConnectionRetryMessage:@"The user has been waiting in the queue, they will be asked to continue/quit here"];
  [components setConnectionTimedOutMessage:@"The session has gone unanswered too long, it has been automatically ended"];

  // Step 2. We want to have a view that we can use and will live for the lifetime of the application. This view will hold our custom UI components.
  //         This lets us manage UI components without having to manage them in a specific view controller.
  CGRect frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  _container = [[MyContainerWindow alloc] initWithFrame:frame];
  _notification = [[[NSBundle mainBundle] loadNibNamed:@"SOSExampleNotification" owner:self options:nil] objectAtIndex:0];

  [_container setWindowLevel:UIWindowLevelAlert - 1000.f];
  [_container addSubview:_notification];
  [_container addSubview:_alert];
  [_container setHidden:NO];

  [_notification setHidden:YES];
  [_notification setUserInteractionEnabled:YES];

  // The MyAlert class requires a view to attach the custom alert to.
  [_myAlert setWindow:_container];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNotificationTouch:)];
  [_notification addGestureRecognizer:tap];

  // Step 3. Add this class to the delegates in SOSSessionManager
  [sos addDelegate:self];
}

#pragma mark - Older Example Code

- (SOSOptions *)getSessionOptions {

  NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
  NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];

  SOSOptions *opts = [SOSOptions optionsWithLiveAgentPod:settings[@"Live Agent Pod"]
                                                   orgId:settings[@"Salesforce Organization ID"]
                                            deploymentId:settings[@"Deployment ID"]];

  [opts setSessionRetryTime:10 * 1000]; // Set the retry prompt for 10 seconds (10,000 ms)

  return opts;
}

- (void)startSession {

  SOSSessionManager *sos = [SOSSessionManager sharedInstance];
  if ([sos state] != SOSSessionStateInactive) {
    // We're either connecting, or are in a session already.
    // Ask the user if they want to stop
    [self stopSession];
    return;
  }

  SOSOptions *opts = [self getSessionOptions];
  [sos startSessionWithOptions:opts];
}

- (void)stopSession {
  // Ask the user if they want to stop
  SOSSessionManager *sos = [SOSSessionManager sharedInstance];
  [sos stopSession];
}

#pragma mark - SOSDelegate Handlers

- (void)sosDidStart:(SOSSessionManager *)sos {
  [_notification showWithMessage:@"Initializing.."];
}

- (void)sosDidConnect:(SOSSessionManager *)sos {
  [_notification showWithMessage:@"Waiting for an Agent.."];
}

- (void)sosAgentJoined:(SOSSessionManager *)sos {
  [_notification showWithMessage:@"Agent has joined"];
  [_notification hideAfterDelay:1.f];
}

#pragma mark - GestureRecognizers

- (void)handleNotificationTouch:(UITapGestureRecognizer *)recognizer {
  [self stopSession];
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

@implementation MyAlert

- (id) init {
  if (self = [super init]) {
    _alert = [[[NSBundle mainBundle] loadNibNamed:@"SOSExampleAlert" owner:self options:nil] objectAtIndex:0];
  }
  return self;
}

- (BOOL)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancel
              confirmTitle:(NSString *)confirm
                      type:(SOSUIAlertNotificationType)type
                completion:(void (^)(BOOL))block {

  BOOL showStandardAlert = NO;

  /**
   * Here is where we decided which alerts will use a custom alert, and which will use the standard. We have done this
   * based on the type of the alert.
   * The alert types are:
   * ConnectionPrompt
   * DisconnectPrompt
   * ConnectionRetryPrompt
   * AgentDisconnected
   * AgentMissing
   * ConnectionTimedOut
   * InsufficientNetworkConditions
   * TestServerNotAvailable
   * AgentNotAvailable
   * DisconnectNetworkReachability
   * DisconnectBackgroundedBeforeConnected
   * ReEstablishAttemptFailed
   */
  switch (type) {
    case ConnectionPrompt:
      [_window addSubview:_alert];
      [_alert showWithMessage:message completion:block];

      break;
    default:
      showStandardAlert = YES;
      _blockInternal = block;

      break;
  }

    return showStandardAlert;
}

- (void)dismissCurrentAlert {

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (_blockInternal) {
    //buttonIndex 0 is cancel
    if(buttonIndex) {
      _blockInternal(YES);
    } else {
      _blockInternal(NO);
    }

    _blockInternal = nil;
  }
}

@end
