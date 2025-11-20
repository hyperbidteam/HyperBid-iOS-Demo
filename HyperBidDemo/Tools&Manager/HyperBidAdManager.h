//
//  HyperBidAdManager.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/3/26.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkSplash/AnyThinkSplash.h>

// Initialization completion callback
typedef void (^HyperBidAdManagerInitFinishBlock)(void);
// Splash ad loading callback
typedef void (^HyperBidAdManagerSplashAdLoadBlock)(BOOL isSuccess);

// Application ID in HyperBid dashboard
#define kHyperBidAppID  @"j69de0de8bab7556"

// Application-level AppKey or account-level AppKey in HyperBid dashboard
#define kHyperBidAppKey @"j17a48b9fc6faa4120a5e1be789b2fc889a43a1c0"

// Cold start splash timeout duration
#define FirstAppOpen_Timeout 8
 
@interface HyperBidAdManager : NSObject

+ (instancetype)sharedManager;
 
/// Initialize SDK
/// - Parameters:
///   - block: Result callback
///   - privacySettingsEnable: Whether to use SDK built-in privacy process (EU GDPR)
- (void)initSDK:(HyperBidAdManagerInitFinishBlock)block privacySettingsEnable:(BOOL)privacySettingsEnable;
 
#pragma mark - Splash ad related

/// Add launch loading view, add before SDK initialization, used for cold start splash
- (void)addLaunchLoadingView;

/// Load splash ad
/// - Parameters:
///   - placementID: Placement ID
///   - block: Result callback
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(HyperBidAdManagerSplashAdLoadBlock)block;

/// Show splash ad
/// - Parameters:
///   - placementID: Placement ID
///   - controller: Target controller
- (void)showSplashWithPlacementID:(NSString *)placementID inController:(UIViewController *)controller;
 

@end


