//
//  AdDisplayVC.h
//  HyperBidDemo
//
//  Created by HyperBid技术支持 on 2025/1/11.
//

#import "BannerVC.h"

#import <AnyThinkNative/AnyThinkNative.h>
 
@interface AdDisplayVC : BaseVC

- (instancetype)initWithAdView:(ATNativeADView *)adView offer:(ATNativeAdOffer *)offer adViewSize:(CGSize)size;
- (instancetype)initWithAdView:(UIView *)adView adViewSize:(CGSize)size;

@end
