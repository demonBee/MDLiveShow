//
//  DBTools.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBTools : NSObject
//计算文件的尺寸
+(CGFloat)folderSize;

//清除缓存
+ (void)removeCache;
//得到UUID
+(NSString *)getUUID;
//得到第一响应者的view
+(UIView*)findFirstResponderBeneathView:(UIView*)view;

#pragma 广告栏需要
//判断文件是否存在
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath;
//根据图片名拼接文件路径
+ (NSString *)getFilePathWithImageName:(NSString *)imageName;
// 下载新图片
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName andshoppingID:(NSString*)idd;
//删除旧图片
+ (void)deleteOldImage;


#pragma 关于时间   这里要区分国际的还是北京的
//获取当前时间戳有两种方法(以秒为单位)
+(NSString *)getNowTimeTimestamp;
//一个很全的时间
+(NSString*)TimeWholeFormat:(NSString*)str;
//传一个时间 转化为00：00：00   扣除了8小时
+(NSString*)TimeLongFormat:(NSString*)str;

//传一个时间 转化为 17：05：02
+(NSString*)TimeStartFormat:(NSString*)str;


//获取视频的时长
+ (NSUInteger)durationWithVideo:(NSURL *)videoUrl;
// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path;

@end
