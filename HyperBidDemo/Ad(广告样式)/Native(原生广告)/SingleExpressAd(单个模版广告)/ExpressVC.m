//
//  ExpressVC.m
//  TPNiOSDemo
//
//  Created by HyperBid技术支持 on 2025/1/18.
//

#import "ExpressVC.h"

#import <MCSDK/MCSDK.h>

#import "AdDisplayVC.h"

@interface ExpressVC () <MCNativeAdDelegate, MCAdRevenueDelegate, MCAdExDelegate, MCNetworkAdSourceDelegate>

@property (nonatomic, strong) MCNativeAdLoader * nativeAdLoader;
@property (nonatomic, strong) MCNativeAdView   * nativeAdView;
@property (nonatomic, strong) MCAdInfo         * adInfo;
@property (nonatomic, assign) BOOL               hasShowAD;
@property (nonatomic, assign) NSInteger          retryAttempt; // 新增重试计数器

@end

@implementation ExpressVC

//广告位ID
#define Native_Express_PlacementID @"kcf2cedc1438f0de"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define Native_Express_SceneID @""

#define ExpressAdWidth (400.f)
#define ExpressAdHeight (300.f)
 
#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    //加载原生广告 - 必要步骤
    if (!self.nativeAdLoader) {
        MCNativeAdLoader *nativeAdLoader = [[MCNativeAdLoader alloc] initWithPlacementId:Native_Express_PlacementID];
        self.nativeAdLoader = nativeAdLoader;
    }
    self.nativeAdLoader.delegate = self;
    self.nativeAdLoader.revenueDelegate = self;
    self.nativeAdLoader.adExDelegate = self;
    self.nativeAdLoader.placement = Native_Express_SceneID;
    //后台选择的4:3 上图下文
    self.nativeAdLoader.templateNativeAdViewSize = CGSizeMake(ExpressAdWidth, ExpressAdHeight);

    //开始加载广告 - 必要步骤
    [self.nativeAdLoader loadAd];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    // 判断当前是否存在可展示的广告
    BOOL isReady = self.nativeAdView ? YES : NO;
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // 当前广告位没有可用缓存，建议重新加载
        [self.nativeAdLoader loadAd];
        return;
    }
    
    //展示广告
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:self.nativeAdView adViewSize:CGSizeMake(ExpressAdWidth, ExpressAdHeight)];
    [self.navigationController pushViewController:showVc animated:YES];
    
    self.hasShowAD = YES;
}
  
#pragma mark - 移除广告
- (void)removeAd {
    if (_adInfo) {
        [self showLog:[NSString stringWithFormat:@"destroy:%@", _adInfo.mediationPlacementId]];
        [self.nativeAdLoader destroyAd];
        _nativeAdView = nil;
        _adInfo = nil;
    }
}

#pragma mark - MCNativeAdDelegate
// 原生加载成功
- (void)didLoadNativeAd:(nullable MCNativeAdView *)nativeAdView forAd:(MCAdInfo *_Nonnull)ad {
    _nativeAdView = nativeAdView;
    _adInfo = ad;
    [self showLog:[NSString stringWithFormat:@"%s, didLoadNativeAd:%@ \n AdView_Object: nativeAdView:%@", __FILE_NAME__, ad,nativeAdView]];
    // 重置重试加载次数
    self.retryAttempt = 0;
}

// 加载失败
- (void)didFailToLoadNativeAdWithError:(MCError *_Nonnull)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadNativeAdWithError，errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    // HyperBid建议您使用指数递增延迟重试，最大延迟时间（在这种情况下为64秒）
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.nativeAdLoader loadAd];
    });
}

// 展示成功
- (void)didDisplayAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// 展示成功
- (void)didHideAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    [self.navigationController popViewControllerAnimated:YES];
    
    // Native ad is hidden. Pre-load the next ad
    // 原生广告已关闭，预加载下一个广告
    [self.nativeAdLoader loadAd];
}

// 展示失败
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Native ad failed to display. Pre-load the next ad.
    // 原生广告播放失败，预加载下一个广告
    [self.nativeAdLoader loadAd];
}

// 点击
- (void)didClickNativeAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickNativeAd:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
// 展示收益
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

- (void)dealloc {
    NSLog(@"ExpressVC dealloc");
}

@end
