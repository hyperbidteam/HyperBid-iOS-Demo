//
//  AppDelegate.m
//  MCSDKDemo
//
//  Created by HyperBid Tech Support on 2025/4/1.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "HyperBidAdManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //开启Demo日志打印
    DemoLogAccess(1);
 
    //布局demoUI,无需接入
    [self setupDemoUI];
    
    //开屏广告展示启动图
    [[HyperBidAdManager sharedManager] addLaunchLoadingView];
    //初始化SDK，在欧盟地区发行的应用，需自行决定是否使用SDK内置隐私流程privacySettingsEnable
    [[HyperBidAdManager sharedManager] initSDK:^{
        //初始化广告SDK完成
        
        //加载开屏广告
        [[HyperBidAdManager sharedManager] loadSplashAdWithPlacementID:FirstAppOpen_PlacementID result:^(BOOL isSuccess) {
            //加载成功
            if (isSuccess) {
                //展示开屏广告
                [[HyperBidAdManager sharedManager] showSplashWithPlacementID:FirstAppOpen_PlacementID inController:self.window.rootViewController];
            }
        }];
    } privacySettingsEnable:YES];
    
    return YES;
}


#pragma mark - Demo UI 可忽略
- (void)setupDemoUI {
    self.window = [UIWindow new];
    self.window.backgroundColor = kHexColor(0xffffff);
    if (@available(iOS 13.0, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
      
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
 
@end
