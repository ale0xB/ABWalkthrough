//
//  TDBWalkthrough.m
//  TDBWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import "TDBWalkthrough.h"
#import "ABVideoLoopViewController.h"

@interface TDBWalkthrough ()

@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) NSString *nibName;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *videoURLs;
@property (strong, nonatomic) NSArray *descriptions;
@property (strong, nonatomic) NSMutableArray *slideTypes;

@end

@implementation TDBWalkthrough


#pragma mark - Initialization

+ (id)sharedInstance
{
    static TDBWalkthrough *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithLove];
    });
    return sharedInstance;
}


- (id)initWithLove
{
    self = [super init];
    
    if (self) {
        self.walkthroughViewController = [[TDBWalkthroughViewController alloc] initWithNibName:nil bundle:nil];
        
        self.className = @"TDBSimpleWhite";
        self.nibName = @"TDBSimpleWhite";
        _videoURLs = [NSMutableArray array];
        _images = [NSMutableArray array];
        _slideTypes = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Page Addition

- (void)addPageWithImage:(UIImage *)image description:(NSString *)description andNibName:(NSString *)nibNameOrNil
{
    NSParameterAssert(image);
    [self.slideTypes addObject:@(ABWalkthroughSlideTypePicture)];
    [self.images addObject:image];
    
    
}

- (void)addPageWithVideoURL:(NSURL *)videoURL andDescription:(NSString *)description
{
    NSParameterAssert(videoURL);
    [self.slideTypes addObject:@(ABWalkthroughSlideTypeVideo)];
    [self.videoURLs addObject:videoURL];
}


#pragma mark - Actions

- (void)show
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
//    [self.walkthroughViewController setupWithClassName:self.className
//                                               nibName:self.nibName
//                                                images:self.images
//                                          descriptions:self.descriptions];
    [self.walkthroughViewController setupForSlideTypes:self.slideTypes usingVideoURLs:self.videoURLs andImages:self.images];
    
    [window.rootViewController presentViewController:self.walkthroughViewController animated:NO completion:nil];
}


- (void)dismiss
{
    [self dismissWithAnimation:UIModalTransitionStyleCoverVertical completion:nil];
}


- (void)dismissWithAnimation:(UIModalTransitionStyle)animation
{
    [self dismissWithAnimation:animation completion:nil];
}


- (void)dismissWithAnimation:(UIModalTransitionStyle)animation completion:(void (^)(void))completion
{
    if (animation) {
        self.walkthroughViewController.modalTransitionStyle = animation;
    }
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController dismissViewControllerAnimated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}

@end
