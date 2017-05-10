//6666
//  AppDelegate.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DBDefault.h"
#import "UserSession.h"

#import "DBBaseViewController.h"

#import "PLMediaStreamingKit.h"

#import <RongIMLib/RongIMLib.h>    //融云聊天室
#import "RCDLiveKitCommonDefine.h"
#import "RCDLive.h"
#import "RCDLiveGiftMessage.h"


#import <UMSocialCore/UMSocialCore.h>
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"


#import "DBNewLoginViewController.h"
#import "XLNavigationController.h"
#import "XLTabBarViewController.h"





@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //融云聊天室
    // 秘钥  lKx7mclZAFC3nB
    [[RCDLive sharedRCDLive] initRongCloud:RONGCLOUD_IM_APPKEY];
    //注册自定义消息
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];


    //中英文
    [DBLanguageTool initUserLanguage];
    
    
    //友盟
    [self setUpUMShare];
    
    
    //七牛云
     [PLStreamingEnv initEnv];
    

    //检测网络状态
    [AppDelegate AFNetworkStatus];
    
    //广告页和引导页在首页上
    
    
    DBNewLoginViewController* vc=[[DBNewLoginViewController alloc]initWithNibName:@"DBNewLoginViewController" bundle:nil];
    XLNavigationController*navi=[[XLNavigationController alloc]initWithRootViewController:vc];
    self.window= [AppDelegate windowInitWithRootViewController:navi];
    
    return YES;
}







#pragma mark  --友盟
//友盟分享
-(void)setUpUMShare{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
     [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58c7c852f5ade420af000d59"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];

    
}

- (void)confitUShareSettings
{
    
    
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1b5d3303d7e63ba6" appSecret:@"d4f6d2e2b4546fcd6b51a3cce05eabe8" redirectURL:@"http://mobile.umeng.com/social"];
    

    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105856597"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1878019184"  appSecret:@"c479daea0949f9a5959b12e7a08c2d73" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}




#pragma mark -- 回调
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//            }];
        }else{
//             return  [WXApi handleOpenURL:url delegate:[DBBaseViewController sharedManager]];
        }

        
        
        return YES;
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url ];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//            }];
        }else{
//            return  [WXApi handleOpenURL:url delegate:[DBBaseViewController sharedManager]];
        }
        
        
        
        return YES;

        
        
    }
    return result;
}





- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}


@end
