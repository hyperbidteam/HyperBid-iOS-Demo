//
//  BaseVC.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/6.
//

#import <UIKit/UIKit.h>
#import "NaviBarView.h"
#import "CustomTableViewCell.h"
#import "NormalNavBar.h"
#import "ATADFootView.h"

@interface BaseVC : UIViewController

@property (nonatomic, strong) ATADFootView *footView;
@property (strong, nonatomic) NaviBarView * bar;
@property (strong, nonatomic) NormalNavBar * nbar;
@property (nonatomic, strong) NSArray *dataSource;
@property (strong, nonatomic) UITableView * tableView;
@property (nonatomic, strong) UITextView *textView;

- (void)addHomeBar;
- (void)addNormalBarWithTitle:(NSString *)title;
- (void)addFootView;
- (void)addLogTextView;
- (void)showLog:(NSString *)logStr;

- (void)notReadyAlert;
- (void)clearLog; 

#pragma mark - actions
- (void)loadAdButtonClickAction;

- (void)showAdButtonClickAction;
 
- (void)hiddenAdButtonClickAction;

- (void)removeAdButtonClickAction;

- (void)reshowAdButtonClickAction;

@end
 
