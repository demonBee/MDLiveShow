//
//  TJPSegementBarConfig.h
//  TJPSengment
//
//  Created by Walkman on 2016/12/8.
//  Copyright © 2016年 tangjiapeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJPSegementBarConfig : NSObject

/** 背景颜色*/
@property (nonatomic, strong) UIColor *segementBarBackColor;
/** 字体正常颜色*/
@property (nonatomic, strong) UIColor *itemNormalColor;
/** 字体选中颜色*/
@property (nonatomic, strong) UIColor *itemSelectedColor;
/** 字体正常字号*/
@property (nonatomic, strong) UIFont *itemNormalFont;
/** 字体选中字号*/
@property (nonatomic, strong) UIFont *itemSelectedFont;



/** 指示器颜色*/
@property (nonatomic, strong) UIColor *indicatorColor;
/** 指示器高度*/
@property (nonatomic, assign) CGFloat indicatorHegiht;
/** 指示器延展宽度*/
@property (nonatomic, assign) CGFloat indicatorExtraW;





+ (instancetype)defaultConfig;











@end
