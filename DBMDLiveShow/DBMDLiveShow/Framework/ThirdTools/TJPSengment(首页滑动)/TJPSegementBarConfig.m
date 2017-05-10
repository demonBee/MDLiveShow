//
//  TJPSegementBarConfig.m
//  TJPSengment
//
//  Created by Walkman on 2016/12/8.
//  Copyright © 2016年 tangjiapeng. All rights reserved.
//

#import "TJPSegementBarConfig.h"

@implementation TJPSegementBarConfig

+ (instancetype)defaultConfig {
    
    TJPSegementBarConfig *config = [[TJPSegementBarConfig alloc] init];
    config.segementBarBackColor = [UIColor clearColor];
    config.itemNormalFont = [UIFont systemFontOfSize:14.f];
    config.itemSelectedFont = [UIFont systemFontOfSize:17.f];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectedColor = [UIColor redColor];
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHegiht = 2;
    config.indicatorExtraW = 10;
    
    return  config;

}

@end
