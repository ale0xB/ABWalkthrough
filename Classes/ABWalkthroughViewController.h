//
//  ABWalkthroughViewController.h
//  ABWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StyledPageControl.h>
#import "ABInterface.h"

@protocol ABWalkthroughViewControllerDelegate;

@interface ABWalkthroughViewController : UIViewController <UIScrollViewDelegate, ABInterfaceDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (readonly, nonatomic) StyledPageControl *pageControl;
@property (assign, nonatomic) id<ABWalkthroughViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL rounderCorners;

- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description;
- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description;

#pragma mark - Setup

- (void)finishSetup;

@end

@protocol ABWalkthroughViewControllerDelegate <NSObject>

- (void)didPressButtonWithTag:(NSInteger)tag;

@end
