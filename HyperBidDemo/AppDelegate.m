//
//  AppDelegate.m
//  MCSDKDemo
//
//  Created by HyperBid Tech Support on 2025/4/1.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"

//Hyberbid sdk header
#import <MCSDK/MCSDK.h>

@interface AppDelegate () <MCInitDelegate, MCMediationUpdateDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Demo log switch
    DemoLogAccess(1);
  
    [self setupDemoUI];
     
    // Some setting before init
    [self globalSDKConfig];
    
    // init SDK
    MCInitConfig *config = [[MCInitConfig alloc] init];
    config.appId = kHyperBidAppID;
    config.appKey = kHyperBidAppKey;
    // Set preset strategy
//    config.defaultStrategyPath = [[NSBundle mainBundle] pathForResource:@"DefaultAppSettings" ofType:nil];
    // When requesting online strategy for the first time, how long to wait before using local default preset strategy, default 0, no waiting
    config.timeoutForUseDefaultStrategy = 0;
    // Whether to use SDK built-in privacy process
    config.privacySettingsEnable = YES;
    [[MCAPI sharedInstance] setMediationUpdateDelegate:self];
    [[MCAPI sharedInstance] initWithConfig:config delegate:self];
  
    return YES;
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
}

/// Mediation platform information update callback
/// - Parameters:
///   - newAppSettings: New mediation platform information
///   - oldAppSettings: Old mediation platform information
- (void)didMediationUpdated:(NSDictionary *)newAppSettings oldAppSettings:(NSDictionary *)oldAppSettings {
    ATDemoLog(@"MC --- update new: %@, old: %@", newAppSettings, oldAppSettings);
}

#pragma mark - Demo UI
- (void)setupDemoUI {
    self.window = [UIWindow new];
    self.window.backgroundColor = kHexColor(0xffffff);
    if (@available(iOS 13.0, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
      
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
 
@end
