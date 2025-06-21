//
//  SelfRenderVC.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/11.
//

#import "SelfRenderVC.h"
 
#import "SelfRenderView.h"
#import "AdDisplayVC.h"

#import <MCSDK/MCSDK.h>

@interface SelfRenderVC () <MCNativeAdDelegate, MCAdRevenueDelegate, MCAdExDelegate, MCNetworkAdSourceDelegate>
 
@property (strong, nonatomic) SelfRenderView   * selfRenderView;

@property (nonatomic, strong) MCNativeAdLoader * nativeAdLoader;
@property (nonatomic, strong) MCNativeAdView   * nativeAdView;
@property (nonatomic, strong) MCAdInfo         * adInfo;
@property (nonatomic, assign) BOOL               hasShowAD;
@property (nonatomic, assign) NSInteger          retryAttempt; // 新增重试计数器

@end

@implementation SelfRenderVC

//广告位ID
#define Native_SelfRender_PlacementID @"k24662fb067ffa5c"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define Native_SelfRender_SceneID @""
 
#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    //加载原生广告 - 必要步骤
    if (!self.nativeAdLoader) {
        MCNativeAdLoader *nativeAdLoader = [[MCNativeAdLoader alloc] initWithPlacementId:Native_SelfRender_PlacementID];
        self.nativeAdLoader = nativeAdLoader;
    }
    self.nativeAdLoader.delegate = self;
    self.nativeAdLoader.revenueDelegate = self;
    self.nativeAdLoader.adExDelegate = self;
    self.nativeAdLoader.placement = Native_SelfRender_SceneID;

    //开始加载广告 - 必要步骤
    [self.nativeAdLoader loadAd];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    // 判断当前是否存在可展示的广告，也就是确认广告是否就绪 - 必要步骤
    BOOL isReady = self.nativeAdView ? YES : NO;
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // 当前广告位没有可用缓存，建议重新加载
        [self.nativeAdLoader loadAd];
        return;
    }
    
    // 创建用于布局自渲染广告的自定义视图 - 必要步骤
    SelfRenderView *selfRenderView = [[SelfRenderView alloc] initWithAdInfo:self.adInfo];
    // 设置其大小和位置
    selfRenderView.frame = self.nativeAdView.frame;
    self.selfRenderView = selfRenderView;
    // 设置广告标识坐标x和y
//    self.nativeAdView.adChoicesViewOrigin = CGPointMake(10, 10);
    // 设置logo坐标大小
//    self.nativeAdView.logoViewFrame = CGRectMake(10, self.nativeAdView.frame.size.height - 20 - 10, 60, 20);
    
    //创建需要绑定广告点击事件的组件数组 - 必要步骤
    NSMutableArray *array = [@[selfRenderView.iconImageView,
                               selfRenderView.titleLabel,
                               selfRenderView.textLabel,
                               selfRenderView.ctaLabel,
                               selfRenderView.mainImageView] mutableCopy];
    
    //注册点击事件 - 必要步骤
    [self.nativeAdView registerClickableViewArray:array];
    
    //指定需要渲染的组件列表 - 必要步骤
    MCNativePrepareInfo *nativePrepareInfo = [MCNativePrepareInfo loadPrepareInfo:^(MCNativePrepareInfo * _Nonnull prepareInfo) {
        //广告内容文本
        prepareInfo.textLabel = selfRenderView.textLabel;
        //广告赞助商
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        //广告标题
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        //广告评分
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        //广告宣传对象的icon
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        //广告主渲染图片
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        //关闭按钮
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        //广告"前往下载"标语
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        //广告媒体视图
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    //绑定需要渲染的组件 - 必要步骤
    [self.nativeAdView prepareWithNativePrepareInfo:nativePrepareInfo];

    //渲染广告 - 必要步骤
    [self.nativeAdLoader rendererWithNativeAdView:self.nativeAdView selfRenderView:selfRenderView adInfo:self.adInfo];
     
    //展示广告，AdDisplayVC仅为示例，您可以结合自身场景设置并添加nativeAdView展示 - 必要步骤
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:self.nativeAdView adViewSize:CGSizeMake(self.selfRenderView.frame.size.width, self.selfRenderView.frame.size.height)];
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
// 原生广告加载成功
- (void)didLoadNativeAd:(nullable MCNativeAdView *)nativeAdView forAd:(MCAdInfo *_Nonnull)ad {
    
    // 自渲染广告需要加载成功后手动创建 MCNativeAdView - 必要步骤
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
    
    // 重置重试加载次数
    self.retryAttempt = 0;
}

/// 广告加载失败
- (void)didFailToLoadNativeAdWithError:(MCError *_Nonnull)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadNativeAdWithError，errorCode:%ld，msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    // HyperBid建议您使用指数递增延迟重试，最大延迟时间（在这种情况下为64秒）
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.nativeAdLoader loadAd];
    });
}

/// 广告展示成功
- (void)didDisplayAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

/// 广告隐藏
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    [self.navigationController popViewControllerAnimated:YES];
    
    // Native ad is hidden. Pre-load the next ad
    // 原生广告已关闭，预加载下一个广告
    [self.nativeAdLoader loadAd];
}

/// 广告展示失败
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // Native ad failed to display. Pre-load the next ad.
    // 原生广告播放失败，预加载下一个广告
    [self.nativeAdLoader loadAd];
}

/// 用户已经点击广告
- (void)didClickNativeAd:(MCAdInfo *_Nonnull)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickNativeAd:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCAdRevenueDelegate
/// 获取广告展示收益
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
    NSLog(@"SelfRenderVC dealloc");
}
   
@end
