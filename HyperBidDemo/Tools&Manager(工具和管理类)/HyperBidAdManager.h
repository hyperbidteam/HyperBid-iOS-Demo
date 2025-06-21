//
//  HyperBidAdManager.h
//  TPNiOSDemo
//
//  Created by HyperBid技术支持 on 2025/3/26.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkSplash/AnyThinkSplash.h>

//初始化完成回调
typedef void (^HyperBidAdManagerInitFinishBlock)(void);
//开屏加载回调
typedef void (^HyperBidAdManagerSplashAdLoadBlock)(BOOL isSuccess);

//在HyperBid后台的应用ID
#define kTopOnAppID  @"j1d267153c917436"

//在HyperBid后台的应用维度AppKey，或者是账号维度AppKey
#define kTopOnAppKey @"7eae0567827cfe2b22874061763f30c9"

//冷启动开屏超时时间
#define FirstAppOpen_Timeout 8

//冷启动开屏广告位ID
#define FirstAppOpen_PlacementID @"k0576b7865e7e37b"

@interface HyperBidAdManager : NSObject

+ (instancetype)sharedManager;
 
/// 初始化SDK
/// - Parameters:
///   - block: 结果回调
///   - privacySettingsEnable: 是否使用SDK内置的隐私流程(欧盟GDPR)
- (void)initSDK:(HyperBidAdManagerInitFinishBlock)block privacySettingsEnable:(BOOL)privacySettingsEnable;
 
#pragma mark - 开屏广告相关

/// 添加启动页,初始化SDK之前添加，用于冷启动开屏
- (void)addLaunchLoadingView;

/// 加载开屏广告
/// - Parameters:
///   - placementID: 广告位ID
///   - block: 结果回调
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(HyperBidAdManagerSplashAdLoadBlock)block;

/// 展示开屏广告
/// - Parameters:
///   - placementID: 广告位ID
///   - controller: 目标控制器
- (void)showSplashWithPlacementID:(NSString *)placementID inController:(UIViewController *)controller;
 

@end


