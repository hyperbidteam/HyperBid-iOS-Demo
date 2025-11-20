//
//  BaseNormalBarVC.m
//  HyperBidDemo
//
//  Created by mac on 2025/9/10.
//

#import "BaseNormalBarVC.h"

@interface BaseNormalBarVC ()

@end

@implementation BaseNormalBarVC

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

@end
