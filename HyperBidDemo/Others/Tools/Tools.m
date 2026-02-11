//
//  Tools.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/11.
//

#import "Tools.h"
 
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation Tools
 

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
