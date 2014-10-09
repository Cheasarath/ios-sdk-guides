//
//  ProfileViewController.m
//  SOSExamples
//
//  Created by Thomas Myrden on 10/9/14.
//  Copyright (c) 2014 goinstant. All rights reserved.
//

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
