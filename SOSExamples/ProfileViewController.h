//
//  ProfileViewController.h
//  SOSExamples
//
//  Created by Thomas Myrden on 10/9/14.
//  Copyright (c) 2014 goinstant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyOffsetConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@end
