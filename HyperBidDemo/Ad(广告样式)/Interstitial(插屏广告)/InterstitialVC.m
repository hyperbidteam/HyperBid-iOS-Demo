//
//  InterstitialVC.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/6.
//

#import "InterstitialVC.h"

#import <MCSDK/MCSDK.h>

//@import AnyThinkInterstitial;
 
@interface InterstitialVC () <MCAdDelegate, MCAdRevenueDelegate, MCAdExDelegate, MCNetworkAdSourceDelegate>

@property (nonatomic, strong) MCInterstitialAd *interstitialAd;
@property (nonatomic, assign) NSInteger retryAttempt; // 新增重试计数器

@end

@implementation InterstitialVC
 
//广告位ID
#define InterstitialPlacementID @"k3aac0da04ceb15e"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define InterstitialSceneID @""

#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    //加载广告 - 必要步骤
    if (!self.interstitialAd) {
        self.interstitialAd = [[MCInterstitialAd alloc] initWithPlacementId:InterstitialPlacementID];
    }
    //设置代理对象
    self.interstitialAd.delegate = self;
    self.interstitialAd.revenueDelegate = self;
    self.interstitialAd.adExDelegate = self;
    self.interstitialAd.adSourceDelegate = self;
 
    //开始加载广告 - 必要步骤
    [self.interstitialAd loadAd];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    
    //检查广告加载状态 - 可选接入
    MCAdStatusInfo *info = [self.interstitialAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    
    // 判断当前是否存在可展示的广告 - 必要步骤
    BOOL isReady = [self.interstitialAd isReady];
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // 当前广告位没有可用缓存，建议重新加载
        [self.interstitialAd loadAd];
        return;
    }
    
    // 展示广告 - 必要步骤
    // kMCAPIPlacementScenarioIDKey为场景ID，场景ID是可选接入项
    [self.interstitialAd showAdWithViewController:self withExtra:@{kMCAPIPlacementScenarioIDKey:InterstitialSceneID}];
}

#pragma mark - 销毁广告
- (void)removeAd {
    //销毁广告 - 必要步骤
    [self.interstitialAd destroyAd];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //这里模拟场景是离开此页面就彻底销毁广告，您的场景中请根据实际情况调用
    [self removeAd];
}

#pragma mark - MCRewardedAdDelegate
// 广告加载成功
- (void)didLoadAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAd:%@", __FILE_NAME__, ad]];
    
    // 重置重试加载次数
    self.retryAttempt = 0;
}

// 广告加载失败
- (void)didFailToLoadAdWithError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError, errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    // HyperBid建议您使用指数递增延迟重试，最大延迟时间（在这种情况下为64秒）
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.interstitialAd loadAd];
    });
}

// 广告展示成功
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// 广告已隐藏
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    
    // Interstitial ad is hidden. Pre-load the next ad
    // 插屏广告已关闭，预加载下一个广告
    [self.interstitialAd loadAd];
}

// 用户点击广告
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// 广告展示失败
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Interstitial ad failed to display. Pre-load the next ad.
    // 插屏广告播放失败，预加载下一个广告
    [self.interstitialAd loadAd];
}

// 广告视频开始
- (void)didAdVideoStarted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoStarted:%@", __FILE_NAME__, ad]];
}

// 广告视频结束
- (void)didAdVideoCompleted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoCompleted:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
// 广告展示收益
- (void)didPayRevenueForAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didPayRevenueForAd:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdExDelegate
// 某次请求结束了
- (void)didAdLoadFinished {
    [self showLog:[NSString stringWithFormat:@"%s, didAdLoadFinished", __FILE_NAME__]];
}
 
#pragma mark - MCNetworkAdSourceDelegate
// 广告源级别回调 - 仅TopOn支持
// Only TopOn Supported
- (void)didNetworkAdSourceEvent:(MCAdSourceEventType)adSourceEventType adInfo:(MCAdInfo *)ad withError:(MCAdSourceError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didNetworkAdSourceEvent:%ld---adInfo:%@---errorCode:%ld", __FILE_NAME__, adSourceEventType, ad, (long)error.code]];
}
 
#pragma mark - Demo Needed 不用接入
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
