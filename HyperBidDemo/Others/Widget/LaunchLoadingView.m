//
//  LaunchLoadingView.m
//  TPNiOSDemo
//
//  Created by HyperBid Tech Support on 2025/1/18.
//

#import "LaunchLoadingView.h"
#import "HyperBidAdManager.h"

@interface LaunchLoadingView()

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@end

@implementation LaunchLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
 
        self.backgroundColor = [UIColor whiteColor];
         
        UIImageView *imageView = [[UIImageView alloc] initWithImage:kImg(@"iPhone App-60")];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
         
        [self addSubview:imageView];
         
        self.timerLabel = [[UILabel alloc] init];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.timerLabel.textColor = [UIColor blackColor];
        self.timerLabel.font = [UIFont systemFontOfSize:16];
        self.timerLabel.text = @"";
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.timerLabel];
         
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
         
        NSLayoutConstraint *labelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *labelTopConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]; // logo下方20点
         
        [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint, labelCenterXConstraint, labelTopConstraint]];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
     
    UIViewController *rootViewController = keyWindow.rootViewController;
    [rootViewController.view addSubview:self];
    
    self.frame = keyWindow.bounds;
}

- (void)startTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
     
    self.seconds = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"%@ 00:00 ,%@:%d",kLocalizeStr(@"Current"),kLocalizeStr(@"TimeoutSetting"),FirstAppOpen_Timeout];
     
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
    self.seconds++;
    NSInteger minutes = self.seconds / 60;
    NSInteger remainingSeconds = self.seconds % 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld ,%@:%d",kLocalizeStr(@"Current") ,(long)minutes, (long)remainingSeconds,kLocalizeStr(@"TimeoutSetting"),FirstAppOpen_Timeout];
    self.timerLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld ,%@:%d",kLocalizeStr(@"Current") ,(long)minutes, (long)remainingSeconds,kLocalizeStr(@"TimeoutSetting"),FirstAppOpen_Timeout];
}

- (void)dismiss {
 
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeFromSuperview];
}

@end
