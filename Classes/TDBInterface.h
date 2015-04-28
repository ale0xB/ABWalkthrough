//
//  TDBSimpleWhite.h
//  TDBWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDBInterfaceDelegate;
@interface TDBInterface : UIViewController

@property (assign, nonatomic) NSUInteger tag;
@property (assign, nonatomic) id<TDBInterfaceDelegate> delegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andTag:(NSInteger)tag;
- (void)setupWithImage:(UIImage *)image andText:(NSString *)text;
- (void)showButtons;

@end

@protocol TDBInterfaceDelegate <NSObject>

- (void)didPressButton:(TDBInterface *)interface;

@end
