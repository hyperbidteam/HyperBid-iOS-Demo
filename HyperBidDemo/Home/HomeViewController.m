//
//  HomeViewController.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/5.
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
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomTableViewCellIdentifier"];
    }
    
    NSDictionary *data = self.dataSource[indexPath.row];
 
    cell.titleLbl.text = data[@"title"];
    cell.subTitleLbl.text = data[@"subtitle"];

    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedItem = self.dataSource[indexPath.row][@"title"];
    
    if ([selectedItem isEqualToString:kLocalizeStr(@"Interstitial")]) {
        InterstitialVC *vc = [[InterstitialVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([selectedItem isEqualToString:kLocalizeStr(@"Rewarded")]) {
        RewardedVC *vc = [[RewardedVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([selectedItem isEqualToString:kLocalizeStr(@"Splash")]) {
        SplashVC *vc = [[SplashVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([selectedItem isEqualToString:kLocalizeStr(@"Banner")]) {
        BannerVC *vc = [[BannerVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([selectedItem isEqualToString:kLocalizeStr(@"Native")]) {
        NativeTypeSelectVC *vc = [[NativeTypeSelectVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //Debug tools
    if ([selectedItem isEqualToString:@"TopOn DebugUI"]) {
        //#import <MCSDK/MCSDK.h>
        [[MCAPI sharedInstance] showMediationDebugger:MCMediationIDTypeTopon viewController:self];
    }
    if ([selectedItem isEqualToString:@"Max Mediation Debugger"]) {
        //#import <MCSDK/MCSDK.h>
        [[MCAPI sharedInstance] showMediationDebugger:MCMediationIDTypeMax viewController:self];
    }
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据源
    self.dataSource = @[
        @{@"title": kLocalizeStr(@"Interstitial"), @"subtitle": kLocalizeStr(@"InterstitialFullScreenDescription")},
        @{@"title": kLocalizeStr(@"Rewarded"), @"subtitle": kLocalizeStr(@"RewardedDescription")},
        @{@"title": kLocalizeStr(@"Splash"), @"subtitle": kLocalizeStr(@"SplashDescription")},
        @{@"title": kLocalizeStr(@"Banner"), @"subtitle": kLocalizeStr(@"BannerDescription")},
        @{@"title": kLocalizeStr(@"Native"), @"subtitle": kLocalizeStr(@"NativeDescription")},
        @{@"title": @"TopOn DebugUI", @"subtitle": kLocalizeStr(@"SDKIntegrationVerification")},
        @{@"title": @"Max Mediation Debugger", @"subtitle": kLocalizeStr(@"SDKIntegrationVerification")}
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
