//
//  Tools.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "Tools.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation Tools

+ (NSDictionary *)getOfferInfo:(ATNativeAdOffer *)nativeAdOffer {
    NSMutableDictionary *extraDic = [NSMutableDictionary dictionary];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.networkFirmID) key:@"networkFirmID"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.title key:@"title"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.mainText key:@"mainText"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.ctaText key:@"ctaText"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.advertiser key:@"advertiser"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.videoUrl key:@"videoUrl"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.logoUrl key:@"logoUrl"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.iconUrl key:@"iconUrl"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.imageUrl key:@"imageUrl"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.mainImageWidth) key:@"mainImageWidth"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.mainImageHeight) key:@"mainImageHeight"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.imageList key:@"imageList"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.videoDuration) key:@"videoDuration"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.videoAspectRatio) key:@"videoAspectRatio"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.nativeExpressAdViewWidth) key:@"nativeExpressAdViewWidth"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.nativeExpressAdViewHeight) key:@"nativeExpressAdViewHeight"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.interactionType) key:@"interactionType"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.mediaExt key:@"mediaExt"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.source key:@"source"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.rating key:@"rating"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.commentNum) key:@"commentNum"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.appSize) key:@"appSize"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.appPrice key:@"appPrice"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.isExpressAd) key:@"isExpressAd"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.isVideoContents) key:@"isVideoContents"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.icon key:@"iconImage"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.logo key:@"logoImage"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.mainImage key:@"mainImage"];
    return extraDic;
}

+ (void)ATDemo_setDict:(NSMutableDictionary *)dict value:(id)value key:(NSString *)key {
    
    if ([key isKindOfClass:[NSString class]] == NO) {
        NSAssert(NO, @"key must str");
    }
    if(key != nil && [key respondsToSelector:@selector(length)] && key.length > 0){
        if ([self isEmpty:value] == NO) {
            dict[key] = value;
        }
//        if (value == nil) {
//            NSAssert(NO, @"value must not equal to nil");
//        }
    }else{
        NSAssert(NO, @"key must not equal to nil");
    }
}

+ (BOOL)isEmpty:(id)object {
    
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
     
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([object respondsToSelector:@selector(length)]) {
        return [object length] == 0;
    }
    
    if ([object respondsToSelector:@selector(count)]) {
        return [object count] == 0;
    }
    return NO;
}

+ (NSString *)getIdfaString {
    NSString *idfaStr = @"";
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
        if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
            return nil;
        } else if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            idfaStr = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString != nil ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : nil;
        }
    } else {
        // Fallback on earlier versions
        idfaStr = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString != nil ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : nil;
    }
    return idfaStr;
}
 

@end
