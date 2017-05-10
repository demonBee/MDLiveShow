//
//  AppDelegate+DBDefault.m
//  Maldives
//
//  Created by 黄佳峰 on 2017/3/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AppDelegate+DBDefault.h"


#import "DBGuideView.h"      //引导页
#import "AdvertiseView.h"     //广告图



@implementation AppDelegate (DBDefault)

/**
 *  初始化UIWindow并赋予根视图
 *
 *  @param rootViewController UIWindow的根视图
 *
 *  @return 自定义的UIWindow
 */
+ (UIWindow *)windowInitWithRootViewController:(UIViewController *)rootViewController{
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    window.rootViewController = rootViewController;
    [window makeKeyAndVisible];
    return window;
}



/**
版本不一样 就显示引导页
 */
+ (void)isFirstOPen{
    NSString * key = @"CFBundleShortVersionString";
    NSString * versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * version = [userDefault objectForKey:key];
    
    if (![versionStr isEqualToString:version]){
        //引导页的view
        DBGuideView*guideView=[[DBGuideView alloc]init];
        [[UIApplication sharedApplication].delegate.window addSubview:guideView];
        [userDefault setObject:versionStr forKey:key];
    }
}


#pragma mark ---- 广告
+(void)makeAdvertComplete:(void(^)(NSString*addressStr))complete{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [DBTools getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [DBTools isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight)];
        advertiseView.filePath = filePath;
        advertiseView.clickAdvertImageBlock = ^(NSString *str) {
            if (complete) {
                complete(str);
            }
            
            
        };
        
        [advertiseView show];
        
    }else{
        //出错的话删除本地图片
        [DBTools deleteOldImage];

    }
    
#warning ---   这里  后台操作
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新  没有的话删除本地图片
    [AppDelegate getAdvertisingImage];
    
    
}


/**
 *  初始化广告页面
 */
+ (void)getAdvertisingImage
{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_advertiseStart];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            if ([data[@"data"] count]<1) {
                //如果是 空字符串 删除本地图片
                [DBTools deleteOldImage];
                return;
            }
            
            NSString*img=data[@"data"][@"img"];
            NSString*address=data[@"data"][@"address"];
            
            NSArray*array=[img componentsSeparatedByString:@"/"];
            NSString*imageName=array.lastObject;
            
            NSString*path=[DBTools getFilePathWithImageName:imageName];
            BOOL isExist = [DBTools isFileExistWithFilePath:path];
            if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
                
                [DBTools downloadAdImageWithUrl:img imageName:imageName andshoppingID:address];
                
            }else{
                
                  [KUSERDEFAULT setValue:imageName forKey:adImageName];
            }
            
            
            
            
            
        }else{
            //出错的话删除本地图片
            [DBTools deleteOldImage];
            
            
        }
        
        
    }];
    
    
}



//监测当前网络状态（网络监听）
+ (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
                case AFNetworkReachabilityStatusUnknown:
           
                [JRToast showWithText:DBGetStringWithKeyFromTable(@"L当前网络状态未知", nil)];
                break;
                case AFNetworkReachabilityStatusNotReachable:
             
                 [JRToast showWithText:DBGetStringWithKeyFromTable(@"L无网络状态", nil)];
                break;
                
                case AFNetworkReachabilityStatusReachableViaWWAN:
           
                 [JRToast showWithText:DBGetStringWithKeyFromTable(@"L当前正在使用流量", nil)];
                break;
                
                case AFNetworkReachabilityStatusReachableViaWiFi:
              
                 [JRToast showWithText:DBGetStringWithKeyFromTable(@"LWiFi网络", nil)];
                
                break;
                
            default:
                break;
        }
        
    }] ;
    
    // 3.开始检测
    [manager startMonitoring];
}







@end
