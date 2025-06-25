//
//  ExpressVC.m
//  TPNiOSDemo
//
//  Created by HyperBid Tech Support on 2025/1/18.
//

#import "ExpressVC.h"

#import <MCSDK/MCSDK.h>

#import "AdDisplayVC.h"

@interface ExpressVC () <MCNativeAdDelegate, MCAdRevenueDelegate>

@property (nonatomic, strong) MCNativeAdLoader * nativeAdLoader;
@property (nonatomic, strong) MCNativeAdView   * nativeAdView;
@property (nonatomic, strong) MCAdInfo         * adInfo;
@property (nonatomic, assign) BOOL               hasShowAD;
@property (nonatomic, assign) NSInteger          retryAttempt; // Added retry counter

@end

@implementation ExpressVC

// Ad placement ID
#define Native_Express_PlacementID @"kcf2cedc1438f0de"

// Scene ID, optional, can be generated in the dashboard. Pass empty string if not available
#define Native_Express_SceneID @""

#define ExpressAdWidth (400.f)
#define ExpressAdHeight (300.f)
 
#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    // Load native ad - required step
    if (!self.nativeAdLoader) {
        MCNativeAdLoader *nativeAdLoader = [[MCNativeAdLoader alloc] initWithPlacementId:Native_Express_PlacementID];
        self.nativeAdLoader = nativeAdLoader;
    }
    self.nativeAdLoader.delegate = self;
    self.nativeAdLoader.revenueDelegate = self;
 
    self.nativeAdLoader.placement = Native_Express_SceneID;
    // dashboard selected 4:3 image on top, text below
    self.nativeAdLoader.templateNativeAdViewSize = CGSizeMake(ExpressAdWidth, ExpressAdHeight);

    // Start loading ad - required step
    [self.nativeAdLoader loadAd];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAdButtonClickAction {
    // Check if there is an ad ready to display
    BOOL isReady = self.nativeAdView ? YES : NO;
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // No available cache for current ad placement, recommend reloading
        [self.nativeAdLoader loadAd];
        return;
    }
    
    // Display ad
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:self.nativeAdView adViewSize:CGSizeMake(ExpressAdWidth, ExpressAdHeight)];
    [self.navigationController pushViewController:showVc animated:YES];
    
    self.hasShowAD = YES;
}
  
#pragma mark - Remove Ad
- (void)removeAd {
    if (_adInfo) {
        [self showLog:[NSString stringWithFormat:@"destroy:%@", _adInfo.mediationPlacementId]];
        [self.nativeAdLoader destroyAd];
        _nativeAdView = nil;
        _adInfo = nil;
    }
}

#pragma mark - MCNativeAdDelegate
// Native ad loaded successfully
- (void)didLoadNativeAd:(nullable MCNativeAdView *)nativeAdView forAd:(MCAdInfo *_Nonnull)ad {
    _nativeAdView = nativeAdView;
    _adInfo = ad;
    [self showLog:[NSString stringWithFormat:@"%s, didLoadNativeAd:%@ \n AdView_Object: nativeAdView:%@", __FILE_NAME__, ad,nativeAdView]];
    // Reset retry loading count
    self.retryAttempt = 0;
}

// Load failed
- (void)didFailToLoadNativeAdWithError:(MCError *_Nonnull)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadNativeAdWithError，errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.nativeAdLoader loadAd];
    });
}

// Display successful
- (void)didDisplayAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// Ad hidden
- (void)didHideAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    [self.navigationController popViewControllerAnimated:YES];
    
    // Native ad is hidden. Pre-load the next ad
    [self.nativeAdLoader loadAd];
}

// Display failed
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Native ad failed to display. Pre-load the next ad.
    [self.nativeAdLoader loadAd];
}

// Click
- (void)didClickNativeAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickNativeAd:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
// Revenue display
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
    NSLog(@"ExpressVC dealloc");
}

@end
