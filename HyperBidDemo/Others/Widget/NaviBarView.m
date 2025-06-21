//
//  NaviBarView.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/5.
//

#import "NaviBarView.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <AnyThinkSDK/ATAPI.h>

@interface NaviBarView()
 
@end

@implementation NaviBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
         
        self.bgImgView = [UIImageView new];
        self.bgImgView.backgroundColor = kRGBColor(107, 78, 229);
        [self addSubview:self.bgImgView];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
 
        self.titleLbl = [UILabel new];
        self.titleLbl.text = @"HyperBid SDK Demo";
        self.titleLbl.textColor = kHexColor(0xffffff);
        self.titleLbl.font = [UIFont boldSystemFontOfSize:18];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(self.titleLbl.font.lineHeight);
        }];
    }
    return self;
}
 

@end
