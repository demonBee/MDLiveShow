//
//  UIImageView+Extension.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

// 播放GIF
- (void)playGifAnim:(NSArray *)images;
// 停止动画
- (void)stopGifAnim;
/**
 请求图片并剪裁
 
 @param url 图片URL
 @param placeHoldImage 占位图
 @param isCircle 是否需要剪裁
 */
- (void)setURLImageWithURL: (NSURL *)url placeHoldImage:(UIImage *)placeHoldImage isCircle:(BOOL)isCircle;



@end
