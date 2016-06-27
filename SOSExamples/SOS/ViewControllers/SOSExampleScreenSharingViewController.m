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

#import "SOSExampleScreenSharingViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface SOSExampleScreenSharingViewController ()

@property (nonatomic, weak) UIView *drawView;
@property (nonatomic, weak) UIView *agentStreamView;

@property (nonatomic, strong) UIView *agentContainer;

@end

static const CGFloat kAgentSize = 120.f;

@implementation SOSExampleScreenSharingViewController

// This determines whether or not you wish to display an agent stream in your view.
// If you return NO you will not receive a view containing the agent video feed.
- (BOOL)willHandleAgentStream {

    // Our example UI will exclude the agent UI.
    return YES;
}

// When this returns yes you will receive updates about the audio level you can use
// to implement an audio meter.
- (BOOL)willHandleAudioLevel {
    return NO;
}

- (BOOL)willHandleLineDrawing {
    return YES;
}

// When this returns yes you will receive screen space coordinates which represent
// the center of where the agent has moved the view. You can use this to update
// the position of your containing view.
- (BOOL)willHandleRemoteMovement {
    return NO;
}

- (void)didReceiveLineDrawView:(UIView * _Nonnull __weak)drawView {
    _drawView = drawView;
}

- (void)didReceiveAgentStreamView:(UIView * _Nonnull __weak)agentStreamView {
    _agentStreamView = agentStreamView;
    [_agentStreamView setFrame:CGRectMake(0, 0, kAgentSize, kAgentSize)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _agentContainer = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-kAgentSize, 0, kAgentSize, kAgentSize)];
    [_agentContainer setBackgroundColor:[UIColor blackColor]];
    [_agentContainer addSubview:_agentStreamView];

    [_drawView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // If you set userInteractionEnabled to YES the drawing will clear on any touch.
    [_drawView setUserInteractionEnabled:YES];
    [_drawView setFrame:[self view].frame];

    [self setupToolBar];
    [[self view] addSubview:_agentContainer];
    [[self view] addSubview:_drawView];
}

- (void)setupToolBar {
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(handlePause:)];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(handleCameraTransition:)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleClose)];

    UIBarButtonItem *muteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Microphone"] style:UIBarButtonItemStylePlain target:self action:@selector(handleMute:)];
    UIBarButtonItem *drawButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Drawing"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDrawing)];
    UIBarButtonItem *agentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AgentVideo"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleAgent)];

    NSArray *buttonItems = [NSArray arrayWithObjects:drawButton, flexibleItem, agentButton, flexibleItem, muteButton, flexibleItem, pauseButton, flexibleItem, cameraButton, flexibleItem, closeButton, nil];
    [toolbar setItems:buttonItems];

    [[self view] addSubview:toolbar];
}

- (void)toggleDrawing {
    [_drawView setHidden:![_drawView isHidden]];
    SCLAlertView *alertView = [SCLAlertView new];

    NSString *message = [NSString stringWithFormat:@"Line drawing is %@!", [_drawView isHidden] ? @"hidden" : @"visible"];
    [alertView showInfo:self title:@"SOS" subTitle:message closeButtonTitle:@"OK" duration:1.0f];
}

- (void)toggleAgent {
    [_agentContainer setHidden:![_agentContainer isHidden]];
}

- (void)handleClose {
    SCLAlertView *alertView = [SCLAlertView new];

    [alertView addButton:@"YES" target:self selector:@selector(handleEndSession:)];
    [alertView showTitle:self title:@"End your SOS Session?" subTitle:nil style:Question closeButtonTitle:@"Cancel" duration:0.0f];
}

@end
