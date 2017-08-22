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
#import "HSDownloadManager.h"   //下载视频用的






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
            if ([data[@"data"] count]<1||data[@"data"]==nil) {
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



//#pragma mark ---- 广告
//+(void)makeAdvertComplete:(void(^)(NSString*addressStr))complete{
//    NSString*ItType=[KUSERDEFAULT valueForKey:ADType];
//    if ([ItType isEqualToString:@"1"]) {
//        //显示图片
//        // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
//        NSString *filePath = [AppDelegate getFilePathWithImageName:[kUserDefaults valueForKey:ADImageAddress]];
//        BOOL isExist = [AppDelegate isFileExistWithFilePath:filePath];
//        if (isExist) {// 图片存在        
//            AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight)];
//            advertiseView.filePath = filePath;
//            advertiseView.clickAdvertImageBlock = ^(NSString *str) {
//                if (complete) {
//                    complete(str);
//                }
//                
//                
//            };
//            
//            [advertiseView show];
//            
//        }else{
//            //出错的话删除本地图片
//            [DBTools deleteOldImage];
//            
//        }
//
//        
//        
//        
//    }else if ([ItType isEqualToString:@"2"]){
//        //显示视频
//        
//    }else{
//        //没有  什么都不显示
//        
//    }
//    
//    
//    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新  没有的话删除本地图片
//    [AppDelegate getAdvertisingImage];
//    
//    
//    
//    
////    //先判断类型  1图片显示  2 视频显示   其他不显示
////    NSString*showType=[KUSERDEFAULT valueForKey:TypeImageOrVideo];
////    if ([showType isEqualToString:@"1"]) {
////        //显示图片
////        // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
////        NSString *filePath = [DBTools getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
////        
////        BOOL isExist = [DBTools isFileExistWithFilePath:filePath];
////        if (isExist) {// 图片存在
////            
////            AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight)];
////            advertiseView.filePath = filePath;
////            advertiseView.clickAdvertImageBlock = ^(NSString *str) {
////                if (complete) {
////                    complete(str);
////                }
////                
////                
////            };
////            
////            [advertiseView show];
////            
////        }else{
////            //出错的话删除本地图片
////            [DBTools deleteOldImage];
////            
////        }
//// 
////        
////        
////    }else if ([showType isEqualToString:@"2"]){
////        //显示视频
////        
////        
////        
////        
////        
////        
////    }else{
////        //单纯出去吊接口  这里不写
////        
////    }
//    
//
//}
//
//
///**
// *  初始化广告页面
// */
//+ (void)getAdvertisingImage
//{
//    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_advertiseStart];
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        
////        data = {
////            type = 2,
////            title = 开启视频,
////            img = http://api.zhiboquan.net/Public/Upload/20170821/15033070667847.png,
////            video = http://meipai.zhiboquan.net/short_video_20170821150552.mp4,
////            video_link = https://www.baidu.com,
////            address = http://news.baidu.com
////        },
////        errorCode = 0
////    }
//
//        
//       [KUSERDEFAULT setObject:data[@"data"][@"type"] forKey:ADType];
//        if (data[@"data"][@"img"]) {
//              [KUSERDEFAULT setObject:data[@"data"][@"img"] forKey:ADImageAddress];
//        }
//        
//        
//        
//        
//        if ([data[@"errorCode"] integerValue]==0) {
//            if (![data[@"data"]||) {
//                //如果是 空字符串 删除本地图片
//                [DBTools deleteOldImage];
//                //删除旧视频
//                return;
//            }
//            
//            NSString*chooseType=data[@"data"][@"type"];   //1图片  2 视频
//            chooseType=@"2";
//            
//            NSString*imgAddress=data[@"data"][@"img"];
//            NSString*ImageLink=data[@"data"][@"address"];
//            
//            NSString*videoAddress=data[@"data"][@"video"];
//            NSString*videoLink=data[@"data"][@"video_link"];
//            
//            if ([chooseType isEqualToString:@"1"]) {
//                //这里是显示图片
//                
//                NSArray*array=[imgAddress componentsSeparatedByString:@"/"];
//                NSString*imageName=array.lastObject;
//                
//                NSString*path=[DBTools getFilePathWithImageName:imageName];
//                BOOL isExist = [DBTools isFileExistWithFilePath:path];
//                if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
//                    //出错的话删除本地图片
//                    [DBTools deleteOldImage];
//                    
//                    [DBTools downloadAdImageWithUrl:imgAddress imageName:imageName andshoppingID:ImageLink];
//                    
//                }else{
//                    
//                    [KUSERDEFAULT setValue:imageName forKey:adImageName];
//                }
//                
//                
//            }else{
//                //这里是 下载视频
//                //            [self downLoadVideoWithUrl]
//                [AppDelegate downLoadVideoWithUrl:videoAddress];
//                
//                
//                
//                
//            }
//
//            
//        }else{
//            //这里是   errorCode 不等于0
//        }
//        
//        
//        
//    }];
//    
//    
//}


//#pragma mark  -- 关于图片的方法
///**
// *  根据图片名拼接文件路径
// */
//+ (NSString *)getFilePathWithImageName:(NSString *)imageName
//{
//    if (imageName) {
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
//        
//        return filePath;
//    }
//    
//    return nil;
//}
//
//
///**
// *  判断文件是否存在
// */
//+ (BOOL)isFileExistWithFilePath:(NSString *)filePath
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDirectory = FALSE;
//    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
//}
//
//
///**
// *  删除旧图片
// */
//+ (void)deleteOldImage
//{
//    NSString *imageName = [KUSERDEFAULT valueForKey:ADImageAddress];
//    if (imageName) {
//        NSString *filePath = [AppDelegate getFilePathWithImageName:imageName];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:filePath error:nil];
//        [KUSERDEFAULT removeObjectForKey:ADImageAddress];
//        [KUSERDEFAULT removeObjectForKey:ADIMageLink];
//    }
//}

//#pragma mark  --关于刷新视频 下载视频 删除视频
//NSString * const downloadUrl1 = @"http://meipai.zhiboquan.net/short_video_20170725165841.mp4";
//
////下载视频
//+(void)downLoadVideoWithUrl:(NSString*)url{
//    url=downloadUrl1;
//      NSLog(@"当前下载量-----%f", [[HSDownloadManager sharedInstance] progress:url]);
//    //没有在下载在中 吊用是下载  如果正在下载 吊用是暂停
//    
//    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString*str = [NSString stringWithFormat:@"%.f%%", progress * 100];
//            MyLog(@"当前下载量  %@",str);
//            
//            
//            
//        });
//    } state:^(DownloadState state) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%u",state);
//            if (state==DownloadStateCompleted) {
//              //完成了  获取地址路径
//               NSString*address=[[NSBundle mainBundle]pathForResource:url ofType:nil];
//                NSLog(@"下载完地址 %@",address);
//                
//                
//            }
//            
//            
//        });
//    }];
//
//    
//    
//}
//
////删除视频
//+(void)deleteVideoWithUrl:(NSString*)url{
//    url=downloadUrl1;
//    [[HSDownloadManager sharedInstance] deleteFile:url];
//    
//    
//}

//删除旧视频

//+ (void)deleteOldVideo
//{
//    NSString *videoAddress = [KUSERDEFAULT valueForKey:videoAddress];
//    if (videoAddress) {
//        NSString *filePath = [self getFilePathWithImageName:imageName];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:filePath error:nil];
//        [KUSERDEFAULT removeObjectForKey:adUrl];
//    }
//}















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
