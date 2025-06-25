//
//  SelfRenderView.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import <UIKit/UIKit.h>
#import <AnyThinkNative/AnyThinkNative.h>
#import <MCSDK/MCSDK.h>

#define SelfRenderViewWidth (kScreenW)
#define SelfRenderViewHeight (350)

#define SelfRenderViewMediaViewWidth (kScreenW)
#define SelfRenderViewMediaViewHeight (350 - kNavigationBarHeight - 150)

@interface SelfRenderView : UIView

@property(nonatomic, strong) UILabel        * advertiserLabel;
@property(nonatomic, strong) UILabel        * textLabel;
@property(nonatomic, strong) UILabel        * titleLabel;
@property(nonatomic, strong) UILabel        * ctaLabel;
@property(nonatomic, strong) UILabel        * ratingLabel;
@property(nonatomic, strong) UIImageView    * iconImageView;
@property(nonatomic, strong) UIImageView    * mainImageView;
@property(nonatomic, strong) UIImageView    * logoImageView;
@property(nonatomic, strong) UIButton       * dislikeButton;

@property(nonatomic, strong) UIView         * mediaView;
  
- (instancetype)initWithAdInfo:(MCAdInfo *)adInfo;
- (void)destory;

@end 
