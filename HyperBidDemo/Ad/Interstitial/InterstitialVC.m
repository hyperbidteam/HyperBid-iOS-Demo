//
//  InterstitialVC.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/6.
//

#import "InterstitialVC.h"

#import <MCSDK/MCSDK.h>

//@import AnyThinkInterstitial;
 
@interface InterstitialVC () <MCAdDelegate, MCAdRevenueDelegate>

@property (nonatomic, strong) MCInterstitialAd *interstitialAd;
@property (nonatomic, assign) NSInteger retryAttempt; // Added retry counter

@end

@implementation InterstitialVC
 
// Ad placement ID
#define InterstitialPlacementID @"k3aac0da04ceb15e"

// Scene ID, optional, can be generated in the dashboard. Pass empty string if not available
#define InterstitialSceneID @""

#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    // Load ad - required step
    if (!self.interstitialAd) {
        self.interstitialAd = [[MCInterstitialAd alloc] initWithPlacementId:InterstitialPlacementID];
    }
    // Set delegate object
    self.interstitialAd.delegate = self;
    self.interstitialAd.revenueDelegate = self;
  
    // Start loading ad - required step
    [self.interstitialAd loadAd];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAdButtonClickAction {
    
    // Check ad loading status - optional integration
    MCAdStatusInfo *info = [self.interstitialAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    
    // Check if there is an ad ready to display - required step
    BOOL isReady = [self.interstitialAd isReady];
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // No available cache for current ad placement, recommend reloading
        [self.interstitialAd loadAd];
        return;
    }
    
    // Display ad - required step
    // kMCAPIPlacementScenarioIDKey is scene ID, scene ID is optional integration
    [self.interstitialAd showAdWithViewController:self withExtra:@{kMCAPIPlacementScenarioIDKey:InterstitialSceneID}];
}

#pragma mark - Destroy Ad
- (void)removeAd {
    // Destroy ad - required step
    [self.interstitialAd destroyAd];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // This simulates the scenario of completely destroying the ad when leaving this page, please call according to actual situation in your scenario
    [self removeAd];
}

#pragma mark - MCRewardedAdDelegate
// Ad loaded successfully
- (void)didLoadAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAd:%@", __FILE_NAME__, ad]];
    
    // Reset retry loading count
    self.retryAttempt = 0;
}

// Ad failed to load
- (void)didFailToLoadAdWithError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError, errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.interstitialAd loadAd];
    });
}

// Ad displayed successfully
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// Ad is hidden
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    
    // Interstitial ad is hidden. Pre-load the next ad
    [self.interstitialAd loadAd];
}

// User clicked ad
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// Ad failed to display
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Interstitial ad failed to display. Pre-load the next ad.
    [self.interstitialAd loadAd];
}

// Ad video started
- (void)didAdVideoStarted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoStarted:%@", __FILE_NAME__, ad]];
}

// Ad video completed
- (void)didAdVideoCompleted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoCompleted:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
// Ad revenue display
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

@end
