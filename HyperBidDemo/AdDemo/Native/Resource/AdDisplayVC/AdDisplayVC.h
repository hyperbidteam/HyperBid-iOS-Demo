//
//  AdDisplayVC.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "BannerVC.h"

#import <MCSDK/MCSDK.h>
 
@interface AdDisplayVC : BaseVC
 
- (instancetype)initWithAdView:(MCNativeAdView *)adView adViewSize:(CGSize)size;

@end
