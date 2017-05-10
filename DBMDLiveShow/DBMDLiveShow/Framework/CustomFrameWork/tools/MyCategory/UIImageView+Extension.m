

//
//  UIImageView+Extension.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

// 播放GIF
- (void)playGifAnim:(NSArray *)images
{
    if (!images.count) {
        return;
    }
    //动画图片数组
    self.animationImages = images;
    //执行一次完整动画所需的时长
    self.animationDuration = 0.5;
    //动画重复次数, 设置成0 就是无限循环
    self.animationRepeatCount = 0;
    [self startAnimating];
}
// 停止动画
- (void)stopGifAnim
{
    if (self.isAnimating) {
        [self stopAnimating];
    }
    [self removeFromSuperview];
}


- (void)setURLImageWithURL: (NSURL *)url placeHoldImage:(UIImage *)placeHoldImage isCircle:(BOOL)isCircle {
    
    if (isCircle) {
        [self sd_setImageWithURL:url placeholderImage:[UIImage circleImage:placeHoldImage borderColor:[UIColor whiteColor] borderWidth:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSLog(@"宽:%f, 高:%f",
                  image.size.width, image.size.height);
            UIImage *resultImage = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:0];
            
            // 6. 处理结果图片
            if (resultImage == nil) return;
            self.image = resultImage;
            
            
        }];
        
    }else {
        [self sd_setImageWithURL:url placeholderImage:placeHoldImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            // 6. 处理结果图片
            if (image == nil) return;
            self.image = image;
            
            
        }];
        
    }
}


@end
