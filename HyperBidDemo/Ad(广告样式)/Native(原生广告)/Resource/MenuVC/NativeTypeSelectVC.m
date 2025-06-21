//
//  NativeTypeSelectVC.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/11.
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
    ATDemoLog(@"Selected: %@", selectedItem); 
    if ([selectedItem isEqualToString:kLocalizeStr(@"自渲染广告")]) {
        SelfRenderVC * vc = [SelfRenderVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([selectedItem isEqualToString:kLocalizeStr(@"模板广告")]) {
        ExpressVC * vc = [ExpressVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNormalBarWithTitle:self.title];
     
    // 初始化数据源
    self.dataSource = @[
        @{@"title": kLocalizeStr(@"自渲染广告"), @"subtitle": kLocalizeStr(@"演示基础的单个自渲染广告")},
        @{@"title": kLocalizeStr(@"模板广告"), @"subtitle": kLocalizeStr(@"演示基础的单个模板广告")},
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
