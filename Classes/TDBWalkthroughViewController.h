//
//  TDBWalkThroughViewController.h
//  TDBWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StyledPageControl.h>
#import "TDBInterface.h"

@protocol TDBWalkthroughViewControllerDelegate;

@interface TDBWalkthroughViewController : UIViewController <UIScrollViewDelegate, TDBInterfaceDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (readonly, nonatomic) StyledPageControl *pageControl;
@property (assign, nonatomic) id<TDBWalkthroughViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL rounderCorners;

- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description;
- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description;

#pragma mark - Setup

- (void)finishSetup;

@end

@protocol TDBWalkthroughViewControllerDelegate <NSObject>

- (void)didPressButtonWithTag:(NSInteger)tag;

@end
