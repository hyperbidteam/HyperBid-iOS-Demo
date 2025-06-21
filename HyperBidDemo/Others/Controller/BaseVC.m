//
//  BaseVC.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/6.
//

#import "BaseVC.h"
#import "TwoButtonAlertView.h"
#import "BaseTabBarController.h"
#import "BannerVC.h"

@interface BaseVC ()

 
@end

@implementation BaseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.view.backgroundColor = kHexColor(0xF2F3F6); 
}

- (void)addHomeBar {
    self.bar = [NaviBarView new];
    [self.view addSubview:self.bar];
     
    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
}

- (void)addNormalBarWithTitle:(NSString *)title {
    self.nbar = [NormalNavBar new];
    [self.view addSubview:self.nbar];
    self.nbar.titleLbl.text = title;
    [self.nbar.arrowImgView addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    [self.nbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
}

- (void)popVC {
    if ([self.tabBarController isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController * tabbar = (BaseTabBarController *)self.tabBarController;
        [tabbar.fromController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomTableViewCellIdentifier"];
    }
    return _tableView;
}
  
- (void)addLogTextView {
    [self.view addSubview:self.textView];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.bar) {
            make.top.equalTo(self.bar.mas_bottom).offset(kAdaptH(15, 15));
        }
        else if (self.nbar) {
            make.top.equalTo(self.nbar.mas_bottom).offset(kAdaptH(15, 15));
        }else {
            make.top.mas_equalTo(self.view.mas_top).offset(kNavigationBarHeight+kAdaptH(15, 15));
        }
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kAdaptW(740, 740));
        make.height.mas_equalTo(kAdaptH(600, 600));
    }];
}

- (void)addFootView {
    [self.view addSubview:self.footView];
    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kAdaptW(740, 740));
        make.height.mas_equalTo(kAdaptH(432, 432));
    }];
    @WeakObj(self)
    [self.footView setClickLoadBlock:^{
        @StrongObj(self);
        [self loadAdButtonClickAction];
    }];
    [self.footView setClickShowBlock:^{
        @StrongObj(self);
        [self showAdButtonClickAction];
    }];
    [self.footView setClickHidenBlock:^{
        @StrongObj(self);
        [self hiddenAdButtonClickAction];
    }];
    [self.footView setClickRemoveBlock:^{
        @StrongObj(self);
        [self removeAdButtonClickAction];
    }];
    [self.footView setClickReShowBlock:^{
        @StrongObj(self);
        [self reshowAdButtonClickAction];
    }];
    [self.footView setClickLogBlock:^{
        @StrongObj(self);
        [self clearLog];
    }];
}

- (void)loadAdButtonClickAction {
    
}

- (void)showAdButtonClickAction {
    
}
 
- (void)hiddenAdButtonClickAction {
    
}

- (void)removeAdButtonClickAction {
    
}

- (void)reshowAdButtonClickAction {
    
}

- (void)clearLog {
    TwoButtonAlertView * al =  [[TwoButtonAlertView alloc] initWithTitle:kLocalizeStr(@"温馨提示") content:kLocalizeStr(@"是否要清空日志") buttonText1:kLocalizeStr(@"否") buttonText2:kLocalizeStr(@"是")];
    @WeakObj(self);
    [al addTwoButtonAlertBlock:^(NSInteger index) {
        @StrongObj(self);
        if (index == 2) {
            self.textView.text = @"";
        }
    }];
    [al show];
}

- (void)notReadyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ad Not Ready!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
 
#pragma mark - 日志
- (void)showLog:(NSString *)logStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n\n%@", logS, logStr];
        } else {
            log = [NSString stringWithFormat:@"%@", logStr];
        }
        self.textView.text = log;
        if(([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)){//横屏
            return;
        }
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}

#pragma mark - lazy
- (ATADFootView *)footView {
    if (!_footView) {
        if ([self isKindOfClass:[BannerVC class]]) {
            _footView = [[ATADFootView alloc] initWithRemoveAndHidenBtn];
        }else {
            _footView = [[ATADFootView alloc] init];
        }
    }
    return _footView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.editable = NO;
        _textView.text = @"";
    }
    return _textView;
}


@end
