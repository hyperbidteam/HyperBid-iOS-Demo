//
//  BannerVC.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/11.
//

#import "BannerVC.h"

#import <MCSDK/MCSDK.h>

@interface BannerVC () <MCBannerAdViewAdDelegate,MCAdRevenueDelegate, MCAdExDelegate, MCNetworkAdSourceDelegate>

//横幅广告的容器
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) MCBannerAdView *bannerView;
@property (nonatomic, assign) BOOL hasLoaded;

@end

@implementation BannerVC

//广告位ID
#define BannerPlacementID @"k85d4f92926b2091"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define BannerSceneID @""

//请注意，banner size需要和后台配置的比例一致
#define BannerSize CGSizeMake(320, 50)

#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    //加载广告 - 必要步骤
    if (!self.bannerView) {
        _bannerView = [[MCBannerAdView alloc] initWithPlacementId:BannerPlacementID adFormat:[MCAdFormat banner]];
    }
    //设置代理对象
    self.bannerView.delegate = self;
    self.bannerView.revenueDelegate = self;
    self.bannerView.adExDelegate = self;
    self.bannerView.adSourceDelegate = self;
    //设置横幅广告尺寸
    self.bannerView.bannerSize = BannerSize;
    //设置场景ID
    self.bannerView.placement = BannerSceneID;
    
    //开始加载广告 - 必要步骤
    [self.bannerView loadAd];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    // 判断当前是否存在可展示的广告
    BOOL isReady = self.hasLoaded;
    if (!isReady) {
        [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"广告没有准备就绪")]];
        return;
    }
    
    if (self.hasLoaded && self.bannerView) {
        self.adView = [[UIView alloc] init];
        self.adView.backgroundColor = UIColor.blueColor;
        [self.adView addSubview:self.bannerView];
        
        [self.view insertSubview:self.adView belowSubview:self.footView];
       
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(BannerSize.height));
            make.width.equalTo(@(BannerSize.width));
            make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(25);
            make.centerX.mas_equalTo(self.view);
        }];
        
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.adView);
        }];
    }
}

#pragma mark - 移除广告
/// 通过demo移除按钮点击来移除banner广告
- (void)removeAdButtonClickAction {
    [self removeAd];
}
  
#pragma mark - 移除广告
- (void)removeAd {
    //移除视图以及引用
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
        [self.bannerView destroyAd];
        _bannerView = nil;
        self.adView = nil;
        self.hasLoaded = NO;
    }
}

// 模拟离开页面移除banner
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeAd];
}

#pragma mark - MCRewardedAdDelegate
// 加载成功
- (void)didLoadAd:(MCAdInfo *)ad {
    self.hasLoaded = YES;
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAd:%@", __FILE_NAME__, ad]];
}

// 加载失败
- (void)didFailToLoadAdWithError:(MCError *)error {
    self.hasLoaded = NO;
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError，errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
}

// 展示成功
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// 隐藏广告
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    [self removeAd];
}

// 点击广告
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// 展示失败
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
}

// 视频开始
- (void)didAdVideoStarted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoStarted:%@", __FILE_NAME__, ad]];
}

// 视频结束
- (void)didAdVideoCompleted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoCompleted:%@", __FILE_NAME__, ad]];
}

#pragma mark - MCBannerAdViewAdDelegate
- (void)didExpandAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didExpandAd:%@", __FILE_NAME__, ad]];
}

- (void)didCollapseAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didCollapseAd:%@", __FILE_NAME__, ad]];
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
    NSLog(@"BannerVC dealloc");
}

@end
