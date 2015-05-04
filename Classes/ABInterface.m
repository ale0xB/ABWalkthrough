//
//  ABInterface.m
//  ABWalkthroughViewController
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import "ABInterface.h"

@interface ABInterface ()

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//@property (strong, nonatomic) IBOutlet UIButton *getStarted;
//@property (strong, nonatomic) IBOutlet UIButton *signIn;
//@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ABInterface

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andTag:(NSInteger)tag
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _tag = tag;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"NSInvalidInit" format:@"Must use the designated initialiser for this class"];
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    [NSException raise:@"NSInvalidInit" format:@"Must use the designated initialiser for this class"];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // text
    self.desc.lineBreakMode = NSLineBreakByWordWrapping;
    self.desc.numberOfLines = 0;
    self.desc.text = self.text;
    
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    
    CGSize expectedLabelSize = [self.text boundingRectWithSize:maximumLabelSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:self.desc.font}
                                                        context:nil].size;
    
    CGRect frame = self.desc.frame;
    frame.size.height = expectedLabelSize.height;
    
    self.desc.frame = frame;
    
    // imageview
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = self.image;
    
    // buttons
    self.button.hidden = YES;
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)setupWithImage:(UIImage *)image andText:(NSString *)text
{
    self.text = text;
    self.image = image;
}


- (void)showButtons
{
    if (!self.button.hidden) {
        return;
    }
    
    self.button.hidden = NO;
    self.button.alpha = 0;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.button.alpha = 1;
                     }
                     completion:nil];
}

#pragma mark - actions

- (IBAction)buttonPressed:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressButton:)]) {
        [self.delegate didPressButton:self];
    }
}

@end
