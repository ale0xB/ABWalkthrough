//
//  ABInterfaceWhite.h
//  ABWalkthroughViewController
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABInterfaceDelegate;
@interface ABInterface : UIViewController

@property (assign, nonatomic) NSUInteger tag;
@property (assign, nonatomic) id<ABInterfaceDelegate> delegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andTag:(NSInteger)tag;
- (void)setupWithImage:(UIImage *)image andText:(NSString *)text;
- (void)showButtons;

@end

@protocol ABInterfaceDelegate <NSObject>

- (void)didPressButton:(ABInterface *)interface;

@end
