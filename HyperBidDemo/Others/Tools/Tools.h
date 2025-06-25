//
//  Tools.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ATNativeAdOffer;
@interface Tools : NSObject

+ (NSDictionary *)getOfferInfo:(ATNativeAdOffer *)nativeAdOffer;

+ (NSString *)getIdfaString;
 

@end

NS_ASSUME_NONNULL_END
