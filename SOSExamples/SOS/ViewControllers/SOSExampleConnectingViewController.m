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
#import "SOSExampleConnectingViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface SOSExampleConnectingViewController()
@property SCLAlertView *alertView;
@end

@implementation SOSExampleConnectingViewController

- (void)loadView {
    [super loadView];
    _alertView = [SCLAlertView new];
}

- (void)initializingNotification {
    [_alertView addButton:@"Cancel" target:self selector:@selector(handleEndSession:)];
    [_alertView showWaiting:self title:@"Connecting" subTitle:@"SOS is booting up" closeButtonTitle:nil duration:0.0f];
}

- (void)waitingForAgentNotification {
    [_alertView dismissViewControllerAnimated:YES completion:nil];
    [_alertView showWaiting:self title:@"Connecting" subTitle:@"SOS has created a session. Waiting for an agent to join" closeButtonTitle:@"HIDE" duration:0.0f];
}

- (void)agentJoinedNotification:(NSString *)name {
    [_alertView dismissViewControllerAnimated:YES completion:nil];
    [_alertView showWaiting:self title:@"Connecting" subTitle:@"An agent has joined your session. Your call will begin shortly" closeButtonTitle:nil duration:0.0f];
}

@end
