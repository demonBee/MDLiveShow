//
//  UIBarButtonItem+TJPItem.h
//  TJPYingKe
//
//  Created by Walkman on 2016/12/8.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TJPItem)

/** 图片创建Item  按图片大小创建的item*/
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target andAction:(SEL)action;

@end
