//
//  ABWalkthroughViewController.m
//  ABWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import "ABWalkthroughViewController.h"
#import "ABInterface.h"
#import "ABVideoLoopViewController.h"
#import <TAPageControl/TADotView.h>
#import <AMPopTip.h>
#import <QuartzCore/QuartzCore.h>


typedef NS_ENUM(NSInteger, ABWalkthroughSlideType) {
    ABWalkthroughSlideTypePicture,
    ABWalkthroughSlideTypeVideo
};

typedef NS_ENUM(NSInteger, ABWalkthroughScrollDirection) {
    ABWalkthroughScrollDirectionLeft,
    ABWalkthroughScrollDirectionRight
};


static CGFloat const ABPercentageMultiplier = 0.4;
static CGFloat const ABMotionFrameOffset    = 15.0;


@interface ABWalkthroughViewController ()

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) NSMutableArray *descriptions;
@property (strong, nonatomic) NSMutableArray *slideTypes;
@property (strong, nonatomic) NSMutableArray *videoFileNames;
@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) TAPageControl *pageControl;

@property (assign, nonatomic) NSInteger otherPageNumber;
@property (assign, nonatomic) CGFloat lastContentOffset;

@end

@implementation ABWalkthroughViewController

CGFloat getFrameHeight(ABWalkthroughViewController *object)
{
    static CGFloat height;
    if (!height) {
        height = CGRectGetHeight(object.view.frame);
    }
    return height;
}

CGFloat getFrameWidth(ABWalkthroughViewController *object)
{
    static CGFloat width;
    if (!width) {
        width = CGRectGetWidth(object.view.frame);
    }
    return width;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewControllers = [NSMutableArray new];
        _descriptions = [NSMutableArray new];
        _slideTypes = [NSMutableArray new];
        _videoFileNames = [NSMutableArray new];
        _images = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.viewControllers makeObjectsPerformSelector:@selector(viewWillAppear:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.showInitialAnimation) {
        [self performInitialAnimation];
    }
    
    if (self.navigationController) {
        [self.viewControllers makeObjectsPerformSelector:@selector(viewDidAppear:)];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(walkthroughViewControllerDidAppear:)]) {
        [self.delegate walkthroughViewControllerDidAppear:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Page Addition

- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description;
{
    NSParameterAssert(image);
    
    [self.images addObject:image];
    [self.slideTypes addObject:@(ABWalkthroughSlideTypePicture)];

    if (description) {
        [self.descriptions addObject:description];
    }
}

- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description;
{
    NSParameterAssert(videoFileName);
    [self.videoFileNames addObject:videoFileName];
    [self.slideTypes addObject:@(ABWalkthroughSlideTypeVideo)];
    
    if (description) {
        [self.descriptions addObject:description];
    }
    
}

#pragma Tooltip

- (void)showTooltipAtPageIndex:(NSUInteger)index withText:(NSString *)text andDuration:(NSTimeInterval)duration
{
    AMPopTip *popTip = [AMPopTip popTip];
    popTip.shouldDismissOnTapOutside = YES;
    [popTip showText:text direction:AMPopTipDirectionUp maxWidth:100.0f inView:[self.viewControllers[index] view] fromFrame:self.pageControl.frame duration:duration];
}

- (void)hideTooltipAtPageIndex:(NSUInteger)index
{
    for (UIView *view in [[self.viewControllers[index] view] subviews]) {
        if ([view isKindOfClass:[AMPopTip class]]) {
            [((AMPopTip *)view) hide];
            break;
        }
    }
}


#pragma mark - Setup Methods

- (void)finishSetup
{
    CGFloat width = getFrameWidth(self);
    CGFloat height = getFrameHeight(self);
    
    NSInteger slideIndex, videoIndex, imageIndex;
    slideIndex = videoIndex = imageIndex = 0;
    
    for (NSNumber *collectionType in self.slideTypes) {
        ABWalkthroughSlideType slideType = collectionType.integerValue;
        UIViewController *viewController;
        if (slideType == ABWalkthroughSlideTypeVideo) {
            NSString *videoFileName = self.videoFileNames[videoIndex++];
            ABVideoLoopViewController *playerViewController = [[ABVideoLoopViewController alloc] initWithNibName:nil bundle:nil];
            playerViewController.resFileName = videoFileName;
            viewController = playerViewController;
//            playerViewController.view.frame = CGRectMake(width * slideIndex, 0, width, height);
//            [self.scrollView addSubview:playerViewController.view];
            [self.viewControllers addObject:playerViewController];
        } else if (slideType == ABWalkthroughSlideTypePicture) {
            UIImage *image = self.images[imageIndex++];
            ABInterface *imageController = [[ABInterface alloc] initWithNibName:@"ABSimpleImage" andTag:slideIndex];
            [imageController setupWithImage:image andText:nil];
            [imageController setDelegate:self];
            viewController = imageController;
//            imageController.view.frame = CGRectMake(width * slideIndex, 0, width, height);
//            [self.scrollView addSubview:imageController.view];
            [self.viewControllers addObject:imageController];
        }
        
        CGFloat diff = 0.0f;
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(width * slideIndex, 0.0f, width, height)];
        UIScrollView *internalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(diff, 0.0f, width - (diff * 2.0), height)];
        internalScrollView.scrollEnabled = NO;
        
        [viewController.view setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(internalScrollView.frame) + ABMotionFrameOffset, CGRectGetHeight(internalScrollView.frame))];
        
        internalScrollView.tag = (slideIndex + 1) * 10;
        viewController.view.tag = (slideIndex + 1) * 1000;
        
        [internalScrollView addSubview:viewController.view];
        [subView addSubview:internalScrollView];
        
        [self.scrollView addSubview:subView];
        
        slideIndex++;
    }

    
    self.scrollView.contentSize = CGSizeMake(width * [self.viewControllers count], height);
    
    
    // Adding Page Control
    [self.view addSubview:self.pageControl];
}


#pragma pageControl
- (TAPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat pageControlY = CGRectGetHeight(self.view.frame) * 0.90;
        _pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, pageControlY, CGRectGetWidth(self.view.frame), 40)];
        [_pageControl setDotViewClass:[TADotView class]];
        [_pageControl setNumberOfPages:[self.viewControllers count]];
        [_pageControl setProgressive:YES];
        [_pageControl setDotSize:CGSizeMake(3, 3)];
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ABWalkthroughScrollDirection scrollDirection;
    CGFloat multiplier = 1.0;
    CGFloat width = getFrameWidth(self);
    
    CGFloat offset = scrollView.contentOffset.x;
    
    if (self.lastContentOffset > offset) {
        scrollDirection = ABWalkthroughScrollDirectionRight;
        if (self.pageControl.currentPage > 0)  {
            if (offset > (self.pageControl.currentPage - 1) * width) {
                self.otherPageNumber = self.pageControl.currentPage + 1;
                multiplier = 1.0;
            } else {
                self.otherPageNumber = self.pageControl.currentPage - 1;
                multiplier = -1.0;
            }
        }
    } else if (self.lastContentOffset < offset) {
        scrollDirection = ABWalkthroughScrollDirectionLeft;
        if (offset < (self.pageControl.currentPage - 1) * width) {
            self.otherPageNumber = self.pageControl.currentPage - 1;
            multiplier = -1.0;
        } else {
            self.otherPageNumber = self.pageControl.currentPage + 1;
            multiplier = 1.0;
        }
    }
    
    self.lastContentOffset = offset;
    
    UIScrollView *internalScrollView = (UIScrollView *)[scrollView viewWithTag:(self.pageControl.currentPage + 1) * 10];
    UIScrollView *otherScrollView = (UIScrollView *)[scrollView viewWithTag:(self.otherPageNumber + 1) * 10];
    
    if (internalScrollView) {
        NSAssert([internalScrollView isKindOfClass:[UIScrollView class]], @"internalScrollView must be of class UIScrollView");
        internalScrollView.contentOffset = CGPointMake(-ABPercentageMultiplier * (offset - (width * self.pageControl.currentPage)), 0.0f);
    }
    
    if (otherScrollView) {
        otherScrollView.contentOffset = CGPointMake(multiplier * ABPercentageMultiplier * width - (ABPercentageMultiplier * (offset - (width * self.pageControl.currentPage))), 0.0f);
        NSAssert([otherScrollView isKindOfClass:[UIScrollView class]], @"otherScrollView must be of class UIScrollView");
    }
    
    // Update the page when more than 50% of the previous/next page is visible
    NSInteger page = self.scrollView.contentOffset.x / getFrameWidth(self);
    [self.pageControl setCurrentPage:(int)page];
    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
        [(ABInterface *)self.viewControllers[self.pageControl.currentPage] showButtons];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIScrollView *internalScrollView = (UIScrollView *)[scrollView viewWithTag:(self.pageControl.currentPage + 1) * 10];
    UIScrollView *otherScrollView = (UIScrollView *)[scrollView viewWithTag:(self.otherPageNumber + 1) * 10];
    
    NSAssert([internalScrollView isKindOfClass:[UIScrollView class]], @"internalScrollView must be of class UIScrollView");
    NSAssert([otherScrollView isKindOfClass:[UIScrollView class]], @"otherScrollView must be of class UIScrollView");
    
    internalScrollView.contentOffset = CGPointMake(0.0f, 0.0f);
    otherScrollView.contentOffset = CGPointMake(0.0f, 0.0f);
    
    NSInteger page = self.scrollView.contentOffset.x / getFrameWidth(self);
    if (self.delegate && [self.delegate respondsToSelector:@selector(walkthroughViewController:didScrollToSlideWithTag:)]) {
        [self.delegate walkthroughViewController:self didScrollToSlideWithTag:page];
    }
}

#pragma mark - ABInterfaceDelegate
- (void)didPressButton:(ABInterface *)interface
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(walkthroughViewController:didPressButtonWithTag:)]) {
        [self.delegate walkthroughViewController:self didPressButtonWithTag:interface.tag];
    }
}

#pragma mark - Effects
- (void)setRounderCorners:(BOOL)rounderCorners
{
    if (rounderCorners) {
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = YES;
    } else {
        self.view.layer.cornerRadius = 1;
        self.view.layer.masksToBounds = NO;
    }
}

#pragma mark - Animation
- (void)performInitialAnimation
{
    CGPoint initialOffset = self.scrollView.contentOffset;
    [UIView animateWithDuration:0.4 animations:^{
        [self.scrollView setContentOffset:CGPointMake(initialOffset.x + 50, initialOffset.y)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView setContentOffset:initialOffset];
        } completion:nil];
    }];
}

//
//- (void)addMotionEffectToView:(UIView *)view magnitude:(CGFloat)magnitude
//{
//    UIInterpolatingMotionEffect *xMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//    UIInterpolatingMotionEffect *yMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//    xMotion.minimumRelativeValue = @(-magnitude);
//    xMotion.maximumRelativeValue = @(magnitude);
//    yMotion.minimumRelativeValue = @(-magnitude);
//    yMotion.maximumRelativeValue = @(magnitude);
//    
//    UIMotionEffectGroup *motionGroup = [[UIMotionEffectGroup alloc] init];
//    motionGroup.motionEffects = @[xMotion, yMotion];
//    [view addMotionEffect:motionGroup];
//}

@end
