//
//  AppDelegate+DBDefault.h
//  Maldives
//
//  Created by 黄佳峰 on 2017/3/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (DBDefault)

/**
 *  初始化UIWindow并赋予根视图
 *
 *  @param rootViewController UIWindow的根视图
 *
 *  @return 自定义的UIWindow
 */
+ (UIWindow *)windowInitWithRootViewController:(UIViewController *)rootViewController;


//引导页
+ (void)isFirstOPen;

//广告图   完成之后的点击事项
+(void)makeAdvertComplete:(void(^)(NSString*addressStr))complete;



//监测当前网络状态（网络监听）
+(void)AFNetworkStatus;










@end
