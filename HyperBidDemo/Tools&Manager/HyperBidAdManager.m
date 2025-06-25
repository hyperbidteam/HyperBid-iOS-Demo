//
//  HyperBidAdManager.m
//  TPNiOSDemo
//
//  Created by HyperBid Tech Support on 2025/3/26.
//

#import "HyperBidAdManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "LaunchLoadingView.h"
#import <MCSDK/MCSDK.h>
#import <FirebaseAnalytics/FIRAnalytics.h>
 
static HyperBidAdManager *sharedManager = nil;

@interface HyperBidAdManager() <MCInitDelegate, MCMediationUpdateDelegate,MCAdDelegate, MCAdRevenueDelegate, MCAdExDelegate>

/// Loading page with custom loading image
@property (strong, nonatomic) LaunchLoadingView * launchLoadingView;
/// Save splash ad callback block
@property (strong, nonatomic) HyperBidAdManagerSplashAdLoadBlock appOpenAdCallback;
 
@property (strong, nonatomic) HyperBidAdManagerInitFinishBlock initBlock;

@property (strong, nonatomic) MCAppOpenAd * appOpenAd;

@end

@implementation HyperBidAdManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HyperBidAdManager alloc] init];
    });
    return sharedManager;
}
  
#pragma mark - public func
/// Initialize SDK
/// - Parameters:
///   - block: Result callback
///   - privacySettingsEnable: Whether to use SDK built-in privacy process (EU GDPR)
- (void)initSDK:(HyperBidAdManagerInitFinishBlock)block privacySettingsEnable:(BOOL)privacySettingsEnable {
    
    self.initBlock = block;

    [self globalSDKConfig];
    // init SDK
    MCInitConfig *config = [[MCInitConfig alloc] init];
    config.appId = kTopOnAppID;
    config.appKey = kTopOnAppKey;
    // Set preset strategy
//    config.defaultStrategyPath = [[NSBundle mainBundle] pathForResource:@"DefaultAppSettings" ofType:nil];
    // When requesting online strategy for the first time, how long to wait before using local default preset strategy, default 0, no waiting
    config.timeoutForUseDefaultStrategy = 0;
    // Whether to use SDK built-in privacy process
    config.privacySettingsEnable = privacySettingsEnable;
    [[MCAPI sharedInstance] setMediationUpdateDelegate:self];
    [[MCAPI sharedInstance] initWithConfig:config delegate:self];
}
 
/// SDK global settings
- (void)globalSDKConfig {
    // Log switch
    [[MCAPI sharedInstance] setLogEnabled:YES];
    
    // Custom rules
    [MCAPI sharedInstance].customData = @{
        kMCCustomDataUserIDKey:@"test_custom_user_id"
    };
    
    // Set personalized ad switch
//    [[MCAPI sharedInstance] setPersonalizedAdState:MCPersonalizedAdStateType];
    // Set data consent level
//    [MCAPI sharedInstance].dataConsentSet = MCDataConsentSetNonpersonalized;
    // Set COPPA rules
//    [MCAPI sharedInstance].isAgeRestrictedUser = YES;
    // Set CCPA rules
//    [MCAPI sharedInstance].doNotSell = YES;
    // Global mute
//    [MCAPI sharedInstance].mute = YES;
    // Set channel
    [MCAPI sharedInstance].channel = @"channel";
    // Set sub-channel
//    [MCAPI sharedInstance].subChannel = @"subChannel";
    
    // Set ad request filter rules
//    MCMediationFilter *filter = [[MCMediationFilter alloc] init];
//    filter.mediationIds = @[@(MCMediationIDTypeMax)];
//    filter.placementMediationIdMap = @{@"k1e6f3b2716ef70c": @[@(MCMediationIDTypeMax)]};
//    [MCAPI sharedInstance].mediationFilter = filter;
}

#pragma mark - Initialization callbacks
/// All mediation initialization finished
/// - Parameters:
///   - successMediationIdList: List of successfully initialized mediation platforms
///   - failedError: Information about failed initialization platforms
- (void)didMediationInitFinished:(NSArray<NSNumber *> *)successMediationIdList failedError:(MCError *)failedError {
    // Initialization result
    ATDemoLog(@"MC --- init: %@,  error: %@",successMediationIdList,failedError);
    if (self.initBlock) {
        self.initBlock();
    }
}

/// Mediation platform information update callback
/// - Parameters:
///   - newAppSettings: New mediation platform information
///   - oldAppSettings: Old mediation platform information
- (void)didMediationUpdated:(NSDictionary *)newAppSettings oldAppSettings:(NSDictionary *)oldAppSettings {
    NSLog(@"MC --- update new: %@, old: %@", newAppSettings, oldAppSettings);
}
  
#pragma mark - Splash ad related
/// Add launch loading view
- (void)addLaunchLoadingView {
    // Add loading page, needs to be removed in delegate after ad display is complete
    self.launchLoadingView = [LaunchLoadingView new];
    [self.launchLoadingView show];
}

/// Load splash ad
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(HyperBidAdManagerSplashAdLoadBlock)block {
    
    [self.launchLoadingView startTimer];
    
    self.appOpenAdCallback = block;
    
    MCAppOpenAd * appOpenAd = [[MCAppOpenAd alloc] initWithPlacementId:placementID containerView:[self footLogoView]];
    // Set delegate
    appOpenAd.delegate = self;
    appOpenAd.revenueDelegate = self;
    appOpenAd.adExDelegate = self;
    // Set greater than 0 to enable, if timeout is set in dashboard, dashboard price priority callback timeout setting shall prevail
    [appOpenAd setLoadAdTimeout:FirstAppOpen_Timeout];
    self.appOpenAd = appOpenAd;
    [appOpenAd loadAd];
}
 
/// Show splash ad
/// - Parameters:
///   - placementID: Placement ID
///   - controller: Target controller
- (void)showSplashWithPlacementID:(NSString *)placementID inController:(UIViewController *)controller {
 
    // Check if there is currently a displayable ad
    BOOL isReady = [self.appOpenAd isReady];
    MCAdStatusInfo *info = [self.appOpenAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    if (!isReady) {
        ATDemoLog(@"App open:%@",kLocalizeStr(@"Ad is not ready"));
        return;
    }
    
    [self.appOpenAd showAdWithWindow:[UIApplication sharedApplication].keyWindow viewController:controller withExtra:@{kMCAPIPlacementScenarioIDKey:@"Scenario ID"}];
}

#pragma mark - Splash ad loading callback handling
- (void)splashCallBackWithResult:(BOOL)result {
    
    if (result == NO) {
        [self.launchLoadingView dismiss];
    }
     
    if (self.appOpenAdCallback) {
        self.appOpenAdCallback(result);
    }
    
    self.appOpenAdCallback = nil;
}

#pragma mark - AppOpen FooterView
/// Optional splash bottom LogoView integration, only supported by some ad platforms
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

#pragma mark - TopOn Ad Loading Delegate
/// Load failed
- (void)didFailToLoadAdWithError:(MCError *)error {
    // Handle splash callback
    [self splashCallBackWithResult:NO];
}

/// Load successful
- (void)didLoadAd:(MCAdInfo *)ad {
    [self splashCallBackWithResult:YES];
}

#pragma mark - MCAdRevenueDelegate
// Display revenue
- (void)didPayRevenueForAd:(MCAdInfo *)ad {
    // Get ad platform name
    NSString *adPlatform;
    switch (ad.mediationId) {
        case MCMediationIDTypeTopon:
            adPlatform = @"TopOn";
            break;
        case MCMediationIDTypeMax:
            adPlatform = @"Max";
            break;
        default:
            adPlatform = @"Your Platform Name";
            break;
    }

    // Create parameters
    NSDictionary *params = @{
        kFIRParameterAdPlatform: adPlatform,
        kFIRParameterAdSource: ad.networkName,
        kFIRParameterAdFormat: ad.format.label,
        kFIRParameterAdUnitName: ad.networkPlacementId,
        kFIRParameterValue: @(ad.revenue),
        kFIRParameterCurrency: ad.currency
    };

    // Report revenue data
    [FIRAnalytics logEventWithName:kFIREventAdImpression parameters:params];
    
    // Please refer to documentation for revenue reporting of other platforms
}

#pragma mark - MCAdExDelegate
- (void)didAdLoadFinished {
    [self splashCallBackWithResult:YES];
}

#pragma mark - Splash ad events
// Load timeout
- (void)didLoadAdTimeout {
    [self splashCallBackWithResult:NO];
}
 
/// Hide
- (void)didHideAd:(MCAdInfo *)ad {
    // Handle splash callback
    [self splashCallBackWithResult:NO];
}

/// Display failed
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self splashCallBackWithResult:NO];
}

/// User clicked ad
- (void)didClickAd:(MCAdInfo *)ad {
    
}
 
/// Ad displayed successfully
- (void)didDisplayAd:(MCAdInfo *)ad {
 
}

 
@end
