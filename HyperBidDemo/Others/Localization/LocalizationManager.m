//
//  LocalizationManager.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/6.
//

#import "LocalizationManager.h"

static LocalizationManager * manager = nil;

@interface LocalizationManager()
 
@property (strong, nonatomic) NSDictionary * info;

@end

@implementation LocalizationManager

+ (LocalizationManager *)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[LocalizationManager alloc] init];
    });
    return manager;
}

- (NSString *)getStringByKey:(NSString *)key {
 
    NSArray * languages = [NSLocale preferredLanguages];
    NSString * string = [languages objectAtIndex:0];
    string = [LocalizationManager languageFormat:string];
    if (![string isEqualToString:@"zh-Hans"] && ![string isEqualToString:@"zh-Hant"] && ![string isEqualToString:@"ko"]) {
        string = @"en";
    }
 
    if (!self.info) {
        NSData * data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"file" ofType:@""]];
        NSError * error;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        self.info = dict;
    }
    NSString * result = [[self.info valueForKey:key] valueForKey:string];
    return result.length==0?@"":result;
}
 
+ (NSString *)languageFormat:(NSString*)language {
    if([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        return @"zh-Hans";
    }
    else if([language rangeOfString:@"zh-Hant"].location != NSNotFound) {
        return @"zh-Hant";
    }
    else {
  
        if([language rangeOfString:@"-"].location != NSNotFound) {
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}

+ (NSString *)getSystemLanguage {
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    return languageName;
}

+ (NSString *)userLang {
    NSString * sysLang = [LocalizationManager getSystemLanguage];
    if ([sysLang containsString:@"Hans"]) {
        sysLang = @"CN";
    }
    else if ([sysLang containsString:@"Hant"]) {
        sysLang = @"TW";
    }
    else if ([sysLang containsString:@"ko"]) {
        sysLang = @"KR";
    }
    else {
        sysLang = @"EN";
    }
    return sysLang;
}
 


@end
