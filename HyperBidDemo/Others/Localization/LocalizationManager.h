//
//  LocalizationManager.h
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/6.
//

#import <Foundation/Foundation.h>
 
#define kLocalizeStr(a) [[LocalizationManager sharedManager] getStringByKey:a]

@interface LocalizationManager : NSObject
 
+ (LocalizationManager *)sharedManager;
 
- (NSString *)getStringByKey:(NSString *)key;

+ (NSString *)getSystemLanguage;

+ (NSString *)userLang;

@end
 
