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

#import "SOSExampleOnboardingViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@implementation SOSExampleOnboardingViewController

// Optionally allows you to skip the onboarding phase entirely.
// If you would prefer to allow a customer to jump directly into a session.
- (BOOL)willHandleConnectionPrompt {
    return YES;
}

- (void)connectionPromptRequested {
    SCLAlertView *alertView = [SCLAlertView new];

    [alertView addButton:@"YES" target:self selector:@selector(handleStartSession:)];   // SOS Expects this selector to be executed to move to the next phase.
    [alertView addButton:@"NO" target:self selector:@selector(handleCancel:)];          // SOS Expects this selector to be executed to cancel and clean up.

    [alertView showTitle:self title:@"Start an SOS Session?" subTitle:nil style:Question closeButtonTitle:nil duration:0.0f];
}

@end