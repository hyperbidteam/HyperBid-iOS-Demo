//
//  NormalNavBar.m
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/7.
//

#import "NormalNavBar.h"

@implementation NormalNavBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
         
        self.bgImgView = [UIImageView new];
        self.bgImgView.backgroundColor =  kRGBColor(107, 78, 229);
        [self addSubview:self.bgImgView];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
 
        self.titleLbl = [UILabel new];
        self.titleLbl.textColor = kHexColor(0xffffff);
        self.titleLbl.font = [UIFont boldSystemFontOfSize:16];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(self.titleLbl.font.lineHeight);
        }];
        
        self.arrowImgView = [[WildClickButton alloc] init];
        [self.arrowImgView setImage:kImg(@"returnImage") forState:0];
        [self addSubview:self.arrowImgView];
        
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLbl);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            make.left.mas_equalTo(self.mas_left).mas_offset(kAdaptW(32, 32));
        }];
    }
    return self;
}

@end
