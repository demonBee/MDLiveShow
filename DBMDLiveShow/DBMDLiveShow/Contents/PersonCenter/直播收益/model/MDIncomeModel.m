//
//  PresentRecordModel.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MDIncomeModel.h"

@implementation MDIncomeModel
//解决关键字冲突
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"giftMB": @"giftmb"};
}


@end
