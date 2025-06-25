//
//  SelfRenderVC.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "SelfRenderVC.h"
 
#import "SelfRenderView.h"
#import "AdDisplayVC.h"

#import <MCSDK/MCSDK.h>

@interface SelfRenderVC () <MCNativeAdDelegate, MCAdRevenueDelegate>
 
@property (strong, nonatomic) SelfRenderView   * selfRenderView;

@property (nonatomic, strong) MCNativeAdLoader * nativeAdLoader;
@property (nonatomic, strong) MCNativeAdView   * nativeAdView;
@property (nonatomic, strong) MCAdInfo         * adInfo;
@property (nonatomic, assign) BOOL               hasShowAD;
@property (nonatomic, assign) NSInteger          retryAttempt; // Added retry counter

@end

@implementation SelfRenderVC

// Ad placement ID
#define Native_SelfRender_PlacementID @"k24662fb067ffa5c"

// Scene ID, optional, can be generated in the dashboard. Pass empty string if not available
#define Native_SelfRender_SceneID @""
 
#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    // Load native ad - required step
    if (!self.nativeAdLoader) {
        MCNativeAdLoader *nativeAdLoader = [[MCNativeAdLoader alloc] initWithPlacementId:Native_SelfRender_PlacementID];
        self.nativeAdLoader = nativeAdLoader;
    }
    self.nativeAdLoader.delegate = self;
    self.nativeAdLoader.revenueDelegate = self;
 
    self.nativeAdLoader.placement = Native_SelfRender_SceneID;

    // Start loading ad - required step
    [self.nativeAdLoader loadAd];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAdButtonClickAction {
    // Check if there is an ad ready to display, confirm if ad is ready - required step
    BOOL isReady = self.nativeAdView ? YES : NO;
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // No available cache for current ad placement, recommend reloading
        [self.nativeAdLoader loadAd];
        return;
    }
    
    // Create custom view for laying out self-rendered ad - required step
    SelfRenderView *selfRenderView = [[SelfRenderView alloc] initWithAdInfo:self.adInfo];
    // Set its size and position
    selfRenderView.frame = self.nativeAdView.frame;
    self.selfRenderView = selfRenderView;
    // Set ad choices view origin x and y coordinates
//    self.nativeAdView.adChoicesViewOrigin = CGPointMake(10, 10);
    // Set logo view frame size
//    self.nativeAdView.logoViewFrame = CGRectMake(10, self.nativeAdView.frame.size.height - 20 - 10, 60, 20);
    
    // Create array of components that need to bind ad click events - required step
    NSMutableArray *array = [@[selfRenderView.iconImageView,
                               selfRenderView.titleLabel,
                               selfRenderView.textLabel,
                               selfRenderView.ctaLabel,
                               selfRenderView.mainImageView] mutableCopy];
    
    // Register click events - required step
    [self.nativeAdView registerClickableViewArray:array];
    
    // Specify list of components to be rendered - required step
    MCNativePrepareInfo *nativePrepareInfo = [MCNativePrepareInfo loadPrepareInfo:^(MCNativePrepareInfo * _Nonnull prepareInfo) {
        // Ad content text
        prepareInfo.textLabel = selfRenderView.textLabel;
        // Ad sponsor
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        // Ad title
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        // Ad rating
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        // Ad promoted object icon
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        // Ad main rendered image
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        // Close button
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        // Ad "Go to download" slogan
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        // Ad media view
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    // Bind components to be rendered - required step
    [self.nativeAdView prepareWithNativePrepareInfo:nativePrepareInfo];

    // Render ad - required step
    [self.nativeAdLoader rendererWithNativeAdView:self.nativeAdView selfRenderView:selfRenderView adInfo:self.adInfo];
     
    // Display ad, AdDisplayVC is just an example, you can set and add nativeAdView display according to your own scenario - required step
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:self.nativeAdView adViewSize:CGSizeMake(self.selfRenderView.frame.size.width, self.selfRenderView.frame.size.height)];
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
    
    // Self-rendered ad needs to manually create MCNativeAdView after successful loading - required step
    if (!nativeAdView) {
        CGFloat scale = 4.0/3.0;
        CGFloat templateViewW = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat templateViewH = templateViewW/scale;
        _nativeAdView = [[MCNativeAdView alloc] initWithFrame:CGRectMake(0, 0, templateViewW, templateViewH)];
    } else {
        _nativeAdView = nativeAdView;
    }
    
    _adInfo = ad;
    [self showLog:[NSString stringWithFormat:@"%s, didLoadNativeAd:%@", __FILE_NAME__, ad]];
    
    // Reset retry loading count
    self.retryAttempt = 0; 
}

/// Ad failed to load
- (void)didFailToLoadNativeAdWithError:(MCError *_Nonnull)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadNativeAdWithError，errorCode:%ld，msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.nativeAdLoader loadAd];
    });
}

/// Ad displayed successfully
- (void)didDisplayAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

/// Ad hidden
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    [self.navigationController popViewControllerAnimated:YES];
    
    // Native ad is hidden. Pre-load the next ad
    [self.nativeAdLoader loadAd];
}

/// Ad failed to display
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Native ad failed to display. Pre-load the next ad.
    [self.nativeAdLoader loadAd];
}

/// User has clicked the ad
- (void)didClickNativeAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickNativeAd:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
/// Get ad display revenue
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
    NSLog(@"SelfRenderVC dealloc");
}
   
@end
