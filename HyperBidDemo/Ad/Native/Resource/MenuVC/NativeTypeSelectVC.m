//
//  NativeTypeSelectVC.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "NativeTypeSelectVC.h"
#import "SelfRenderVC.h"
#import "ExpressVC.h"

@interface NativeTypeSelectVC () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation NativeTypeSelectVC

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
    
    if ([selectedItem isEqualToString:kLocalizeStr(@"SelfRenderAd")]) {
        SelfRenderVC *vc = [[SelfRenderVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([selectedItem isEqualToString:kLocalizeStr(@"ExpressAd")]) {
        ExpressVC *vc = [[ExpressVC alloc] init];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}
  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNormalBarWithTitle:self.title];
     
    // 初始化数据源
    self.dataSource = @[
        @{@"title": kLocalizeStr(@"SelfRenderAd"), @"subtitle": kLocalizeStr(@"SelfRenderAdDescription")},
        @{@"title": kLocalizeStr(@"ExpressAd"), @"subtitle": kLocalizeStr(@"ExpressAdDescription")},
    ];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.nbar.mas_bottom);
    }];
}

@end
