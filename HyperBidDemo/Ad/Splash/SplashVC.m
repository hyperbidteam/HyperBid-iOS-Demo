//
//  SplashWithCustomBG.m
//  TPNiOSDemo
//
//  Created by HyperBid Tech Support on 2025/1/18.
//

#import "SplashVC.h"

#import <MCSDK/MCSDK.h>

@interface SplashVC () <MCAdDelegate, MCAdRevenueDelegate>

@property (nonatomic, strong) MCAppOpenAd *appOpenAd;
@property (nonatomic, assign) NSInteger retryAttempt; // Added retry counter

@end

// This is our recommended integration method
@implementation SplashVC

// Ad placement ID
#define SplashPlacementID @"k0576b7865e7e37b"

// Scene ID, optional, can be generated in the dashboard. Pass empty string if not available
#define SplashSceneID @""

#define Splash_Timeout 8
 
#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    // Load ad - required step
    if (!self.appOpenAd) {
        self.appOpenAd = [[MCAppOpenAd alloc] initWithPlacementId:SplashPlacementID containerView:[self footLogoView]];
    }
    self.appOpenAd.delegate = self;
    self.appOpenAd.revenueDelegate = self;
 
    // Set greater than 0 to enable, if timeout is set in darhboard, darhboard price priority callback timeout setting takes precedence, recommended to set
    [self.appOpenAd setLoadAdTimeout:Splash_Timeout];
    
    [self.appOpenAd setLoadExtraParameter:@{
        @"userData": @"test_userData"
    }];
    
    [self.appOpenAd setExtraParameter:@{
        @"test_extra_key": @"test_extra_value"
    }];
     
    // Start loading ad - required step
    [self.appOpenAd loadAd];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAdButtonClickAction {
    
    // Check ad loading status - optional integration
    MCAdStatusInfo *info = [self.appOpenAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    
    // Check if there is an ad ready to display - required step
    BOOL isReady = [self.appOpenAd isReady];
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // Current ad placement has no available cache, recommend reloading
        [self.appOpenAd loadAd];
        return;
    }
    
    // Show ad - required step
    // kMCAPIPlacementScenarioIDKey is scene ID, scene ID is optional integration
    [self.appOpenAd showAdWithWindow:[UIApplication sharedApplication].keyWindow viewController:self withExtra:@{kMCAPIPlacementScenarioIDKey:SplashSceneID}];
}
 
#pragma mark - AppOpen FooterView
/// Optional integration splash bottom LogoView - optional integration
- (UIView *)footLogoView {
    
    // Width is screen width, height <= 25% of screen height (depending on ad platform requirements)
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    // Add image
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = footerCtrView.frame;
    [footerCtrView addSubview:logoImageView];
    
    // Add click event
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerImgClick:)];
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:tap];
     
    return footerCtrView;
}

/// Footer click event
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    ATDemoLog(@"footer click !!");
}
  
#pragma mark - MCRewardedAdDelegate
// Load successful
- (void)didLoadAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAd:%@", __FILE_NAME__, ad]];
     
    // Reset retry loading count
    self.retryAttempt = 0;
    
    // Retrieve customized parameters
    NSString *originDataJsonString = ad.originData;
}

// Load timeout
- (void)didLoadAdTimeout {
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAdTimeout", __FILE_NAME__]];
}

// Load failed
- (void)didFailToLoadAdWithError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError，errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.appOpenAd loadAd];
    });
}

// Display successful
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// Hidden
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    
    // App Open ad is hidden. Pre-load the next ad
    // [self.appOpenAd loadAd];
}

// Click
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// Display failed
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // App Open ad failed to display. Pre-load the next ad.
    // [self.appOpenAd loadAd];
}

// Video started
- (void)didAdVideoStarted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoStarted:%@", __FILE_NAME__, ad]];
}

// Video completed
- (void)didAdVideoCompleted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoCompleted:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
// Display revenue
- (void)didPayRevenueForAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didPayRevenueForAd:%@", __FILE_NAME__, ad]];
}
 
#pragma mark - Demo Needed - No need to integrate
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setupDemoUI];
}

- (void)setupDemoUI {
    [self addNormalBarWithTitle:self.title];
    [self addLogTextView];
    [self addFootView];
}

- (void)dealloc {
    NSLog(@"SplashCommonVC dealloc");
}

@end



