//
//  HomeViewController.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/5.
//

#import "HomeViewController.h"
#import "InterstitialVC.h"
#import "RewardedVC.h"
#import "SplashVC.h"
#import "BannerVC.h"
#import "NativeTypeSelectVC.h"
#import <MCSDK/MCSDK.h>
 
@interface HomeViewController () <UITableViewDelegate,UITableViewDataSource>
 
@end

@implementation HomeViewController
 
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0; // 每个cell的高度
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomTableViewCellIdentifier"];
    }
    
    NSDictionary *data = self.dataSource[indexPath.row];
    // 配置cell的titleLbl和subTitleLbl的文本
    cell.titleLbl.text = data[@"title"];
    cell.subTitleLbl.text = data[@"subtitle"];

    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedItem = self.dataSource[indexPath.row][@"title"];
    ATDemoLog(@"Selected: %@", selectedItem);
    
    //Interstitial Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"插屏广告")]) {
        InterstitialVC * vc = [InterstitialVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //RewardVideo Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"激励广告")]) {
        RewardedVC * vc = [RewardedVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //Splash Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"开屏广告")]) {
        SplashVC * vc = [SplashVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //Banner Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"横幅广告")]) {
        BannerVC * vc = [BannerVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //Native Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"原生广告")]) {
        NativeTypeSelectVC * vc = [NativeTypeSelectVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //Debug tools
    if ([selectedItem isEqualToString:@"TopOn DebugUI"]) {
        //#import <MCSDK/MCSDK.h>
        [[MCAPI sharedInstance] showMediationDebugger:MCMediationIDTypeTopon viewController:self];
    }
    if ([selectedItem isEqualToString:@"Max Mediation Debugger"]) {
        //#import <MCSDK/MCSDK.h>
        //需要初始化完毕
        [[MCAPI sharedInstance] showMediationDebugger:MCMediationIDTypeMax viewController:self];
    }
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据源
    self.dataSource = @[
        @{@"title": kLocalizeStr(@"插屏广告"), @"subtitle": kLocalizeStr(@"包含插屏和全屏广告")},
        @{@"title": kLocalizeStr(@"激励广告"), @"subtitle": kLocalizeStr(@"用户可通过观看视频广告来换取应用内奖励")},
        @{@"title": kLocalizeStr(@"开屏广告"), @"subtitle": kLocalizeStr(@"应用冷、热启动后立即显示")},
        @{@"title": kLocalizeStr(@"横幅广告"), @"subtitle": kLocalizeStr(@"灵活的格式，可以出现在应用的顶部、中部或底部")},
        @{@"title": kLocalizeStr(@"原生广告"), @"subtitle": kLocalizeStr(@"与您的原生应用代码兼容性最强的视频广告")},
        @{@"title": @"TopOn DebugUI", @"subtitle": kLocalizeStr(@"验证SDK的接入情况、测试已接入广告平台")},
        @{@"title": @"Max Mediation Debugger", @"subtitle": kLocalizeStr(@"验证SDK的接入情况、测试已接入广告平台")}
    ];
     
    [self addHomeBar];
     
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.bar.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
