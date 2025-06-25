//
//  BannerVC.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "BannerVC.h"

#import <MCSDK/MCSDK.h>

@interface BannerVC () <MCBannerAdViewAdDelegate,MCAdRevenueDelegate>

// Container for banner ad
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) MCBannerAdView *bannerView;
@property (nonatomic, assign) BOOL hasLoaded;

@end

@implementation BannerVC

// Ad placement ID
#define BannerPlacementID @"k85d4f92926b2091"

// Scene ID, optional, can be generated in the dashboard. Pass empty string if not available
#define BannerSceneID @""

// Please note that banner size needs to match the ratio configured in the dashboard
#define BannerSize CGSizeMake(320, 50)

#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAdButtonClickAction {
    [self showLog:[NSString stringWithFormat:@"%@",kLocalizeStr(@"点击了加载广告")]];
    
    // Load ad - required step
    if (!self.bannerView) {
        _bannerView = [[MCBannerAdView alloc] initWithPlacementId:BannerPlacementID adFormat:[MCAdFormat banner]];
    }
    // Set delegate object
    self.bannerView.delegate = self;
    self.bannerView.revenueDelegate = self;
 
    // Set banner ad size
    self.bannerView.bannerSize = BannerSize;
    // Set scene ID
    self.bannerView.placement = BannerSceneID;
    
    [self.bannerView setLoadExtraParameter:@{
        @"userData": @"test_userData"
    }];
     
    [self.bannerView setExtraParameter:@{
        @"test_extra_key": @"test_extra_value"
    }];
    
    // Start loading ad - required step
    [self.bannerView loadAd];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAdButtonClickAction {
    // Check if there is an ad ready to display
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

#pragma mark - Remove Ad
/// Remove banner ad through demo remove button click
- (void)removeAdButtonClickAction {
    [self removeAd];
}
  
#pragma mark - Remove Ad
- (void)removeAd {
    // Remove view and references
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
        [self.bannerView destroyAd];
        _bannerView = nil;
        self.adView = nil;
        self.hasLoaded = NO;
    }
}

// Simulate removing banner when leaving the page
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeAd];
}

#pragma mark - MCRewardedAdDelegate
// Load successful
- (void)didLoadAd:(MCAdInfo *)ad {
    self.hasLoaded = YES;
    [self showLog:[NSString stringWithFormat:@"%s, didLoadAd:%@", __FILE_NAME__, ad]];
    
    // Retrieve customized parameters
    NSString *originDataJsonString = ad.originData;
}

// Load failed
- (void)didFailToLoadAdWithError:(MCError *)error {
    self.hasLoaded = NO;
    [self showLog:[NSString stringWithFormat:@"%s, didFailToLoadAdWithError，errorCode:%ld, msg:%@", __FILE_NAME__, (long)error.code,error.message]];
}

// Display successful
- (void)didDisplayAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didDisplayAd:%@", __FILE_NAME__, ad]];
}

// Hide ad
- (void)didHideAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didHideAd:%@", __FILE_NAME__, ad]];
    [self removeAd];
}

// Click ad
- (void)didClickAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didClickAd:%@", __FILE_NAME__, ad]];
}

// Display failed
- (void)didFailToDisplayAd:(MCAdInfo *)ad withError:(MCError *)error {
    [self showLog:[NSString stringWithFormat:@"%s, didFailToDisplayAd:%@，errorCode:%ld, msg:%@", __FILE_NAME__, ad, (long)error.code,error.message]];
}

// Video started
- (void)didAdVideoStarted:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didAdVideoStarted:%@", __FILE_NAME__, ad]];
}

// Video completed
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
// Revenue display
- (void)didPayRevenueForAd:(MCAdInfo *)ad {
    [self showLog:[NSString stringWithFormat:@"%s, didPayRevenueForAd:%@", __FILE_NAME__, ad]];
}
 
#pragma mark - Demo Needed - No need to integrate
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
