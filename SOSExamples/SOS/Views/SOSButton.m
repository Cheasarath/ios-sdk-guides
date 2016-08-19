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

#import "SOSButton.h"
#import "SOSExampleOnboardingViewController.h"
#import "SOSExampleConnectingViewController.h"
#import "SOSExampleScreenSharingViewController.h"

#import <SCLAlertView-Objective-C/SCLAlertView.h>

@import ServiceSOS;

@implementation SOSButton

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    SOSSessionManager *sos = [[SCServiceCloud sharedInstance] sos];

    [sos startSessionWithOptions:[self options]];
}

/**
 *  Simple way to generate an SOSOptions object to be consumed by a session.
 *  In our simple case we will grab this information from the SOSSettings.plist
 *
 *  @return an SOSOptions instance to be consumed by an SOS Session.
 */
- (SOSOptions *)options {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *configuredViewControllers = settings[@"Custom ViewControllers"];

    // NOTE: By default the valies in the SOSSettings.plist are not valid and will result in an error on session start.
    // Be sure to change those to match the credentials provided to you.
    SOSOptions *opts = [SOSOptions optionsWithLiveAgentPod:settings[@"Live Agent Pod"]
                                                     orgId:settings[@"Salesforce Organization ID"]
                                              deploymentId:settings[@"Deployment ID"]];

    [opts setFeatureClientBackCameraEnabled:YES];
    [opts setFeatureClientFrontCameraEnabled:YES];

    if ([configuredViewControllers[@"Onboarding"] boolValue]) {
        [opts setViewControllerClass:[SOSExampleOnboardingViewController class] for:SOSUIPhaseOnboarding];
    }

    if ([configuredViewControllers[@"Connecting"] boolValue]) {
        [opts setViewControllerClass:[SOSExampleConnectingViewController class] for:SOSUIPhaseConnecting];
    }

    if ([configuredViewControllers[@"Screen Sharing"] boolValue]) {
        [opts setViewControllerClass:[SOSExampleScreenSharingViewController class] for:SOSUIPhaseScreenSharing];
    }

    return opts;
}

@end