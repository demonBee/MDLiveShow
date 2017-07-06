//
//  DBTools.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "DBTools.h"
#import "AdvertiseView.h"   //宏
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation DBTools

#pragma mark  --  哈希算法
//sha1加密方式
+ (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}


//得到view 的父视图控制器
+(UIViewController*)getSuperViewWithsubView:(UIView*)subView{
    
    for (UIView* next = [subView superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


// 缓存大小
+(CGFloat)folderSize{
    CGFloat folderSize;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}



+ (void)removeCache{
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                
            }else{
                
                NSLog(@"清除失败");
                
            } 
        }
    }
}



#pragma mark  --  get UUID
#define KEY_USERNAME_PASSWORD @"YWUUDID"   //UUDID
+(NSString *)getUUID{
    NSString * strUUID = [KUSERDEFAULT valueForKey:KEY_USERNAME_PASSWORD];
    if (strUUID)return strUUID;
    strUUID = (NSString *)[DBTools load:@"com.company.app.usernamepassword"];
    
    if ([strUUID isEqualToString:@""] || !strUUID){
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        [DBTools save:KEY_USERNAME_PASSWORD data:strUUID];
        [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:KEY_USERNAME_PASSWORD];
    }
    return strUUID;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}






#pragma mark  -- 广告位需要
/**
 *  判断文件是否存在
 */
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}


/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName andshoppingID:(NSString*)idd
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [KUSERDEFAULT setValue:imageName forKey:adImageName];
            if ([idd isEqualToString:@""]) {
                
            }else{
                [KUSERDEFAULT setValue:idd forKey:adUrl];
                
            }
            
            [KUSERDEFAULT synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}


/**
 *  删除旧图片
 */
+ (void)deleteOldImage
{
    NSString *imageName = [KUSERDEFAULT valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [KUSERDEFAULT removeObjectForKey:adUrl];
    }
}





#pragma 关于时间
//获取当前时间戳有两种方法(以秒为单位)

+(NSString*)getTime{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}


+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



//一个很全的时间
+(NSString*)TimeWholeFormat:(NSString*)str{
    //这个是 北京时区
    NSDate*Strdate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[str intValue]];
//    //得到当前时区
//    NSTimeZone * zone = [NSTimeZone systemTimeZone];
//    //当前时区和国际时区差了多少秒  28800秒
//    NSInteger interval = [zone secondsFromGMTForDate:Strdate];
//    //得到伦敦时区的时间
//    NSDate*londonDate=[Strdate dateByAddingTimeInterval:-interval];
    
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yy:MM:dd--HH:mm:ss"];
    NSString*getTimer=[dateFormatter stringFromDate:Strdate];
    
    
    
    return getTimer;

    
}


//传一个时间 转化为00：00：00    扣除了8小时
+(NSString*)TimeLongFormat:(NSString*)str{
    //这个是 北京时区
    NSDate*Strdate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[str intValue]];
//得到当前时区
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
//当前时区和国际时区差了多少秒  28800秒
    NSInteger interval = [zone secondsFromGMTForDate:Strdate];
 //得到伦敦时区的时间
    NSDate*londonDate=[Strdate dateByAddingTimeInterval:-interval];

    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
//    @"yy:MM:dd"
    [dateFormatter setDateFormat:@" HH:mm:ss"];
    NSString*getTimer=[dateFormatter stringFromDate:londonDate];
    
    
    
    return getTimer;
}

//传一个时间 转化为 17：05：02
+(NSString*)TimeStartFormat:(NSString*)str{
     NSDate*Strdate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[str intValue]];
//    //得到当前时区
//    NSTimeZone * zone = [NSTimeZone systemTimeZone];
//    //当前时区和国际时区差了多少秒  28800秒
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    //得到伦敦时区
//    NSDate*londonDate=[date dateByAddingTimeInterval:-interval];

    
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy:MM:dd"];
    NSString*getTimer=[dateFormatter stringFromDate:Strdate];
    
    return getTimer;

}



+(UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}




// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(1.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}


//获取视频的时长
+ (NSUInteger)durationWithVideo:(NSURL *)videoUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    return second;
}


@end
