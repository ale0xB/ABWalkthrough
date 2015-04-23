//
//  TDBWalkthrough.h
//  TDBWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDBWalkThroughViewController.h"

typedef NS_ENUM(NSInteger, ABWalkthroughSlideType) {
    ABWalkthroughSlideTypePicture,
    ABWalkthroughSlideTypeVideo
};

@protocol TDBWalkthroughDelegate

@optional
- (void)didPressButtonWithTag:(NSInteger)tag;

@end



@interface TDBWalkthrough : NSObject

@property (strong, nonatomic) NSObject<TDBWalkthroughDelegate>* delegate;

@property (strong, nonatomic) TDBWalkthroughViewController *walkthroughViewController;

#pragma mark - Singleton

+ (id)sharedInstance;

#pragma mark - Page Addition

- (void)addPageWithImage:(UIImage *)image description:(NSString *)description andNibName:(NSString *)nibNameOrNil;
- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description;


#pragma mark - Actions

/**
 *  Show walkthrough
 */
- (void)showInWindow:(UIWindow *)window;


/**
 *  Dismiss walkthrough
 */
- (void)dismiss;


/*
 *  Dismiss walkthrough with animation
 *
 *  @param animation The animation (UIModalTransitionStyle)
 */
- (void)dismissWithAnimation:(UIModalTransitionStyle)animation;


/**
 *  Dismiss walkthrough with animation and execute completion handler
 *
 *  @param animation  The animation (UIModalTransitionStyle)
 *  @param completion The completion handler
 */
- (void)dismissWithAnimation:(UIModalTransitionStyle)animation completion:(void (^)(void))completion;


@end
