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
#import <QuartzCore/QuartzCore.h>


@interface ABWalkthroughViewController ()

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) NSMutableArray *videoPlayers;
@property (strong, nonatomic) NSMutableArray *descriptions;

@property (strong, nonatomic) StyledPageControl *pageControl;
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
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        _viewControllers = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Page Addition

- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description;
{
    NSParameterAssert(image);
    
    CGFloat width = getFrameWidth(self);
    CGFloat height = getFrameHeight(self);
    
    NSUInteger indexToAdd = [self.viewControllers count];
    ABInterface *imageController = [[ABInterface alloc] initWithNibName:@"ABSimpleWhite" andTag:indexToAdd];
    [imageController setupWithImage:image andText:nil];
    [imageController setDelegate:self];
    imageController.view.frame = CGRectMake(width * indexToAdd, 0, width, height);
    [self.scrollView addSubview:imageController.view];
    [self.viewControllers addObject:imageController];

    if (description) {
        [self.descriptions addObject:description];
    }
}

- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description;
{
    NSParameterAssert(videoFileName);
    
    CGFloat width = getFrameWidth(self);
    CGFloat height = getFrameHeight(self);
    
    NSUInteger indexToAdd = [self.viewControllers count];
    ABVideoLoopViewController *playerViewController = [[ABVideoLoopViewController alloc] initWithNibName:nil bundle:nil];
    playerViewController.resFileName = videoFileName;
    playerViewController.view.frame = CGRectMake(width * indexToAdd, 0, width, height);
    [self.scrollView addSubview:playerViewController.view];
    [self.viewControllers addObject:playerViewController];
}


#pragma mark - Setup Methods

- (void)finishSetup
{
    CGFloat width = getFrameWidth(self);
    CGFloat height = getFrameHeight(self);
    
    self.scrollView.contentSize = CGSizeMake(width * [self.viewControllers count], height);
    
    // Adding Page Control
    [self.view addSubview:self.pageControl];
}


#pragma pageControl
- (StyledPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat pageControlHeigth = CGRectGetHeight(self.view.frame) * 0.80;
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(100, pageControlHeigth, 120, 30)];
        [_pageControl setNumberOfPages:[self.viewControllers count]];
        [_pageControl setPageControlStyle:PageControlStyleStrokedCircle];
        [_pageControl setCurrentPage:(int)0];
        [_pageControl setCoreNormalColor:[UIColor clearColor]];
        [_pageControl setCoreSelectedColor:[UIColor whiteColor]];
        [_pageControl setStrokeNormalColor:[UIColor whiteColor]];
        [_pageControl setStrokeSelectedColor:[UIColor whiteColor]];
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat width = getFrameWidth(self);
    NSInteger page = floor((self.scrollView.contentOffset.x - width / 2) / width) + 1;
    [self.pageControl setCurrentPage:(int)page];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
        [(ABInterface *)self.viewControllers[self.pageControl.currentPage] showButtons];
    }
}

#pragma mark - ABInterfaceDelegate
- (void)didPressButton:(ABInterface *)interface
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressButtonWithTag:)]) {
        [self.delegate didPressButtonWithTag:interface.tag];
    }
}

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

@end
