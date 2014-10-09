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

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self adjustAssetDimensionsAfterRotation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self adjustAssetDimensionsBeforeRotation];
}

- (void)adjustAssetDimensionsAfterRotation
{
  [self adjustAssetDimensions:NO];
}

- (void)adjustAssetDimensionsBeforeRotation
{
  [self adjustAssetDimensions:YES];
}

- (void)adjustAssetDimensions:(BOOL)before
{
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth;
  if (before) {
    screenWidth = screenRect.size.height;
  } else {
    screenWidth = screenRect.size.width;
  }
  
  CGFloat nameOffsetMultiplier = -.828125;
  CGFloat companyOffsetMultiplier = -.878125;
  CGFloat nameLabelMultiplier = 0.08125;
  CGFloat companyLabelMultiplier = 0.05;
  
  self.nameLabel.font = [UIFont systemFontOfSize:screenWidth*nameLabelMultiplier];
  self.companyLabel.font = [UIFont systemFontOfSize:screenWidth*companyLabelMultiplier];
  
  self.nameOffsetConstraint.constant = screenWidth*nameOffsetMultiplier;
  self.companyOffsetConstraint.constant = screenWidth*companyOffsetMultiplier;
  
  self.imageViewWidthConstraint.constant = screenWidth;
}

@end
