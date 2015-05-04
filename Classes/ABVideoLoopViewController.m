//
//  ABVideoLoopViewController.m
//  Pods
//
//  Created by Alejandro Benito Santos on 21/04/2015.
//
//

#import "ABVideoLoopViewController.h"
#import <AVAnimator/AVAnimatorMedia.h>
#import <AVAnimator/AVAnimatorLayer.h>
#import <AVAsset2MvidResourceLoader.h>
#import <AVMvidFrameDecoder.h>
#import <AVFileUtil.h>

@interface ABVideoLoopViewController ()

@property (strong, nonatomic) AVAnimatorLayer *animatorLayer;
@property (strong, nonatomic) AVAnimatorMedia *media;

@end


@implementation ABVideoLoopViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //init
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    
    [self prepareVideo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.media startAnimator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)prepareVideo
{
    CALayer *mainLayer = self.view.layer;
    CALayer *renderLayer = [[CALayer alloc] init];
    
    renderLayer.backgroundColor = [UIColor whiteColor].CGColor;
    renderLayer.masksToBounds = YES;
    
    CGRect rendererFrame = self.view.layer.frame;
    renderLayer.frame = rendererFrame;
    
    renderLayer.position = CGPointMake(CGRectGetMidX(rendererFrame), CGRectGetMidY(rendererFrame));
    [mainLayer addSublayer:renderLayer];
    
    AVAnimatorLayer *avAnimatorLayer = [AVAnimatorLayer aVAnimatorLayer:renderLayer];
    
    self.media = [AVAnimatorMedia aVAnimatorMedia];
    
    AVAsset2MvidResourceLoader *resLoader = [AVAsset2MvidResourceLoader aVAsset2MvidResourceLoader];
    
    
    NSString *tmpFileName = [[self.resFileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"mvid"];
    NSString *tmpPath = [AVFileUtil getTmpDirPath:tmpFileName];
    
    resLoader.movieFilename = self.resFileName;
    resLoader.outPath = tmpPath;
    
    self.media.resourceLoader = resLoader;
    self.media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
    
    self.media.animatorRepeatCount = INT_MAX;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animatorDoneNotification:) name:AVAnimatorDoneNotification object:self.media];
    
    [avAnimatorLayer attachMedia:self.media];
    
    self.animatorLayer = avAnimatorLayer;
    
    [self.media prepareToAnimate];
    
;
}


- (void)animatorDoneNotification:(NSNotification*)notification {
    NSLog( @"animatorDoneNotification" );
    
    // Unlink all notifications
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self stopAnimator];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
