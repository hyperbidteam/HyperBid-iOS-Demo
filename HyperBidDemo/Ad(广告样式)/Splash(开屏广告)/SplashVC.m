//
//  SplashWithCustomBG.m
//  TPNiOSDemo
//
//  Created by HyperBid技术支持 on 2025/1/18.
//

#import "SplashVC.h"

#import <MCSDK/MCSDK.h>

@interface SplashVC () <MCAdDelegate, MCAdRevenueDelegate, MCAdExDelegate, MCNetworkAdSourceDelegate>

@property (nonatomic, strong) MCAppOpenAd *appOpenAd;
@property (nonatomic, assign) NSInteger retryAttempt; // 新增重试计数器

@end

/// 这是我们推荐的集成方式
@implementation SplashVC

//广告位ID
#define SplashPlacementID @"k0576b7865e7e37b"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define SplashSceneID @""

#define Splash_Timeout 8
 
#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    //加载广告 - 必要步骤
    if (!self.appOpenAd) {
        self.appOpenAd = [[MCAppOpenAd alloc] initWithPlacementId:SplashPlacementID containerView:[self footLogoView]];
    }
    self.appOpenAd.delegate = self;
    self.appOpenAd.revenueDelegate = self;
    self.appOpenAd.adExDelegate = self;
    // 设置大于0开启，如果后台设置了超时时间，以后台价格优先回调超时时间设置为准,建议设置
    [self.appOpenAd setLoadAdTimeout:Splash_Timeout];
    //开始加载广告 - 必要步骤
    [self.appOpenAd loadAd];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    
    //检查广告加载状态 - 可选接入
    MCAdStatusInfo *info = [self.appOpenAd checkStatusInfo];
    ATDemoLog(@"check info: %@", info);
    
    // 判断当前是否存在可展示的广告 - 必要步骤
    BOOL isReady = [self.appOpenAd isReady];
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        // 当前广告位没有可用缓存，建议重新加载
        [self.appOpenAd loadAd];
        return;
    }
    
    // 展示广告 - 必要步骤
    // kMCAPIPlacementScenarioIDKey为场景ID，场景ID是可选接入项
    [self.appOpenAd showAdWithWindow:[UIApplication sharedApplication].keyWindow viewController:self withExtra:@{kMCAPIPlacementScenarioIDKey:SplashSceneID}];
}
 
#pragma mark - AppOpen FooterView
/// 可选接入开屏底部LogoView - 可选接入
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
  
#pragma mark - MCRewardedAdDelegate
// 加载成功
- (void)didLoadAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAd:%@", __FILE_NAME__, ad]];
     
    // 重置重试加载次数
    self.retryAttempt = 0;
}

// 加载超时
- (void)didLoadAdTimeout {
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAdTimeout", __FILE_NAME__]];
}

// 加载失败
- (void)didFailToLoadAdWithError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError，errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
    
    // HyperBid recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    // HyperBid建议您使用指数递增延迟重试，最大延迟时间（在这种情况下为64秒）
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.appOpenAd loadAd];
    });
}

// 展示成功
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// 隐藏
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    
    // App Open ad is hidden. Pre-load the next ad
    // 开屏广告已关闭，推荐热启动预加载下一个广告
    // [self.appOpenAd loadAd];
}

// 点击
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// 展示失败
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
    
    // App Open ad failed to display. Pre-load the next ad.
    // 开屏广告已关闭，推荐热启动预加载下一个广告
    // [self.appOpenAd loadAd];
}

// 视频开始
- (void)didAdVideoStarted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoStarted:%@", __FILE_NAME__, ad]];
}

// 视频结束
- (void)didAdVideoCompleted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoCompleted:%@", __FILE_NAME__, ad]];
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
    NSLog(@"SplashCommonVC dealloc");
}

@end



