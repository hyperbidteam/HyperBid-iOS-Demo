//
//  NormalNavBar.h
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/7.
//

#import <UIKit/UIKit.h>
#import "WildClickButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface NormalNavBar : UIView

@property (strong, nonatomic) WildClickButton * arrowImgView;
@property (strong, nonatomic) UIImageView * bgImgView;
@property (strong, nonatomic) UILabel * titleLbl;

@end

NS_ASSUME_NONNULL_END
