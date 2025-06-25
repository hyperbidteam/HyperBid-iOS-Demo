//
//  HyperBidAdManager.h
//  TPNiOSDemo
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
#define kTopOnAppID  @"j1d267153c917436"

// Application-level AppKey or account-level AppKey in HyperBid dashboard
#define kTopOnAppKey @"7eae0567827cfe2b22874061763f30c9"

// Cold start splash timeout duration
#define FirstAppOpen_Timeout 8

// Cold start splash ad placement ID
#define FirstAppOpen_PlacementID @"k0576b7865e7e37b"

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


