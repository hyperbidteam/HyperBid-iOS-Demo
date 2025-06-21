//
//  HyperBidAdManager.m
//  TPNiOSDemo
//
//  Created by HyperBid技术支持 on 2025/3/26.
//

#import "HyperBidAdManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "LaunchLoadingView.h"
#import <MCSDK/MCSDK.h>
#import <FirebaseAnalytics/FIRAnalytics.h>
 
static HyperBidAdManager *sharedManager = nil;

@interface HyperBidAdManager() <MCInitDelegate, MCMediationUpdateDelegate,MCAdDelegate, MCAdRevenueDelegate, MCAdExDelegate>

/// 加载页面，使用自己的加载图
@property (strong, nonatomic) LaunchLoadingView * launchLoadingView;
/// 保存开屏广告回调block
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
/// 初始化SDK
/// - Parameters:
///   - block: 结果回调
///   - privacySettingsEnable: 是否使用SDK内置的隐私流程(欧盟GDPR)
- (void)initSDK:(HyperBidAdManagerInitFinishBlock)block privacySettingsEnable:(BOOL)privacySettingsEnable {
    
    self.initBlock = block;

    [self globalSDKConfig];
    // init SDK
    MCInitConfig *config = [[MCInitConfig alloc] init];
    config.appId = kTopOnAppID;
    config.appKey = kTopOnAppKey;
    //设置预置策略
//    config.defaultStrategyPath = [[NSBundle mainBundle] pathForResource:@"DefaultAppSettings" ofType:nil];
    //第一次请求线上策略时，等待多久使用本地默认预置策略，默认 0，不等待
    config.timeoutForUseDefaultStrategy = 0;
    //是否使用sdk内置的隐私流程
    config.privacySettingsEnable = privacySettingsEnable;
    [[MCAPI sharedInstance] setMediationUpdateDelegate:self];
    [[MCAPI sharedInstance] initWithConfig:config delegate:self];
}
 
/// SDK全局设置
- (void)globalSDKConfig {
    // 日志开关
    [[MCAPI sharedInstance] setLogEnabled:YES];
    
    //自定义规则
    [MCAPI sharedInstance].customData = @{
        kMCCustomDataUserIDKey:@"test_custom_user_id"
    };
    
    //设置广告个性化开关
//    [[MCAPI sharedInstance] setPersonalizedAdState:MCPersonalizedAdStateType];
    //设置数据同意等级
//    [MCAPI sharedInstance].dataConsentSet = MCDataConsentSetNonpersonalized;
    //设置coppa规则
//    [MCAPI sharedInstance].isAgeRestrictedUser = YES;
    //设置ccpa规则
//    [MCAPI sharedInstance].doNotSell = YES;
    //全局静音
//    [MCAPI sharedInstance].mute = YES;
    // 设置渠道Channel
    [MCAPI sharedInstance].channel = @"channel";
    // 设置子渠道SubChannel
//    [MCAPI sharedInstance].subChannel = @"subChannel";
    
    //设置广告请求过滤规则
//    MCMediationFilter *filter = [[MCMediationFilter alloc] init];
//    filter.mediationIds = @[@(MCMediationIDTypeMax)];
//    filter.placementMediationIdMap = @{@"k1e6f3b2716ef70c": @[@(MCMediationIDTypeMax)]};
//    [MCAPI sharedInstance].mediationFilter = filter;
}

#pragma mark - 初始化回调
/// 全部聚合初始化结束
/// - Parameters:
///   - successMediationIdList: 初始化成功的聚合平台列表
///   - failedError: 初始化失败的平台信息
- (void)didMediationInitFinished:(NSArray<NSNumber *> *)successMediationIdList failedError:(MCError *)failedError {
    // 初始化结果
    ATDemoLog(@"MC --- init: %@,  error: %@",successMediationIdList,failedError);
    if (self.initBlock) {
        self.initBlock();
    }
}

/// 聚合平台信息更新回调
/// - Parameters:
///   - newAppSettings: 新的聚合平台信息
///   - oldAppSettings: 旧的聚合平台信息
- (void)didMediationUpdated:(NSDictionary *)newAppSettings oldAppSettings:(NSDictionary *)oldAppSettings {
    NSLog(@"MC --- update new: %@, old: %@", newAppSettings, oldAppSettings);
}
  
#pragma mark - 开屏广告相关
/// 添加启动页
- (void)addLaunchLoadingView {
    //添加加载页面，当广告显示完毕后需要在代理中移除
    self.launchLoadingView = [LaunchLoadingView new];
    [self.launchLoadingView show];
}

/// 加载开屏广告
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(HyperBidAdManagerSplashAdLoadBlock)block {
    
    [self.launchLoadingView startTimer];
    
    self.appOpenAdCallback = block;
    
    MCAppOpenAd * appOpenAd = [[MCAppOpenAd alloc] initWithPlacementId:placementID containerView:[self footLogoView]];
    //设置代理
    appOpenAd.delegate = self;
    appOpenAd.revenueDelegate = self;
    appOpenAd.adExDelegate = self;
    // 设置大于0开启，如果后台设置了超时时间，以后台价格优先回调超时时间设置为准
    [appOpenAd setLoadAdTimeout:FirstAppOpen_Timeout];
    self.appOpenAd = appOpenAd;
    [appOpenAd loadAd];
}
 
/// 展示开屏广告
/// - Parameters:
///   - placementID: 广告位ID
///   - controller: 目标控制器
- (void)showSplashWithPlacementID:(NSString *)placementID inController:(UIViewController *)controller {
 
    // 判断当前是否存在可展示的广告
    BOOL isReady = [self.appOpenAd isReady];
    MCAdStatusInfo *info = [self.appOpenAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    if (!isReady) {
        ATDemoLog(@"App open:%@",kLocalizeStr(@"广告没有准备就绪"));
        return;
    }
    
    [self.appOpenAd showAdWithWindow:[UIApplication sharedApplication].keyWindow viewController:controller withExtra:@{kMCAPIPlacementScenarioIDKey:@"场景id"}];
}

#pragma mark - 开屏广告加载回调判断
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
/// 可选接入开屏底部LogoView，仅部分广告平台支持
- (UIView *)footLogoView {
    
    //宽度为屏幕宽度,高度<=25%的屏幕高度(根据广告平台要求而定)
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    //添加图片
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = footerCtrView.frame;
    [footerCtrView addSubview:logoImageView];
    
    //添加点击事件
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerImgClick:)];
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:tap];
     
    return footerCtrView;
}

/// footer点击事件
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    ATDemoLog(@"footer click !!");
}

#pragma mark - TopOn Ad Loading Delegate
/// 加载失败
- (void)didFailToLoadAdWithError:(MCError *)error {
    //处理开屏回调
    [self splashCallBackWithResult:NO];
}

/// 加载成功
- (void)didLoadAd:(MCAdInfo *)ad {
    [self splashCallBackWithResult:YES];
}

#pragma mark - MCAdRevenueDelegate
// 展示收益
- (void)didPayRevenueForAd:(MCAdInfo *)ad {
    // 获取广告平台名称
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

    // 创建参数
    NSDictionary *params = @{
        kFIRParameterAdPlatform: adPlatform,
        kFIRParameterAdSource: ad.networkName,
        kFIRParameterAdFormat: ad.format.label,
        kFIRParameterAdUnitName: ad.networkPlacementId,
        kFIRParameterValue: @(ad.revenue),
        kFIRParameterCurrency: ad.currency
    };

    // 上报收益数据
    [FIRAnalytics logEventWithName:kFIREventAdImpression parameters:params];
    
    //其他平台收益上报请参考文档实现
}

#pragma mark - MCAdExDelegate
- (void)didAdLoadFinished {
    [self splashCallBackWithResult:YES];
}

#pragma mark - 开屏广告事件
// 加载超时
- (void)didLoadAdTimeout {
    [self splashCallBackWithResult:NO];
}
 
/// 隐藏
- (void)didHideAd:(MCAdInfo *)ad {
    //处理开屏回调
    [self splashCallBackWithResult:NO];
}

/// 展示失败
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self splashCallBackWithResult:NO];
}

/// 用户已点击广告
- (void)didClickAd:(MCAdInfo *)ad {
    
}
 
/// 广告已成功展示
- (void)didDisplayAd:(MCAdInfo *)ad {
 
}

 
@end
