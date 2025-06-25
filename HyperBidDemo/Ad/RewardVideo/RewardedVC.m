//  RewardedVC.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/7.
//

#import "RewardedVC.h"
#import <MCSDK/MCSDK.h>

@interface RewardedVC () <MCRewardedAdDelegate, MCAdRevenueDelegate>

@property (nonatomic, strong) MCRewardedAd *rewardedAd;
@property (nonatomic, assign) NSInteger retryAttempt;

@end

@implementation RewardedVC

// Ad placement ID
#define RewardedPlacementID @"k73ca0b005957f81"

// Scene ID, optional, can be generated in the dashboard. Pass empty string if not available
#define RewardedSceneID @""

#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    // Load ad - required step
    if (!self.rewardedAd) {
        self.rewardedAd = [[MCRewardedAd alloc] initWithPlacementId:RewardedPlacementID];
    }
    self.rewardedAd.delegate = self;
    self.rewardedAd.revenueDelegate = self;
    
    [self.rewardedAd setLoadExtraParameter:@{
        // Set reward custom parameters
        kMCRewardedAdLoadExtraRewardNameKey: @"RewardName1",
        kMCRewardedAdLoadExtraRewardAmountKey: @(100),
    }];
    
    [self.rewardedAd setExtraParameter:@{
         @"test_extra_key": @"test_extra_value"
    }];
    
    // Start loading ad - required step
    [self.rewardedAd loadAd];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAdButtonClickAction {
    
    // Check ad loading status - optional integration
    MCAdStatusInfo *info = [self.rewardedAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    
    // Check if there is an ad ready to display - required step
    BOOL isReady = [self.rewardedAd isReady];
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // Current ad placement has no available cache, recommend reloading
        [self.rewardedAd loadAd];
        return;
    }
    
    // Show ad - required step
    // kMCAPIPlacementScenarioIDKey is scene ID, scene ID is optional integration
    [self.rewardedAd showAdWithViewController:self withExtra:@{kMCAPIPlacementScenarioIDKey:RewardedSceneID}];
}

#pragma mark - Destroy Ad
- (void)removeAd {
    // Destroy ad - required step
    [self.rewardedAd destroyAd];
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
    
    // Retrieve customized parameters
    NSString *originDataJsonString = ad.originData;
}

// Load failed
- (void)didFailToLoadAdWithError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError, errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.rewardedAd loadAd];
    });
}

// Display successful
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// Ad closed
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    
    // Rewarded ad is hidden. Pre-load the next ad
    [self.rewardedAd loadAd];
}

// Ad clicked
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// Display failed
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Rewarded ad failed to display. AppLovin recommends that you load the next ad.
    [self.rewardedAd loadAd];
}

// Reward granted
- (void)didRewardUserForAd:(MCAdInfo *)ad withReward:(MCReward *)reward {
    [self showLog:[NSString stringWithFormat:@"%s, didRewardUserForAd:%@", __FILE_NAME__, ad]];
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
// Get display revenue
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
