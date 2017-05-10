//
//  MDLevelModel.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MDLevelModel.h"

@implementation MDLevelModel

//解决关键字冲突
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"Live_allMoney": @"total_gift_money",@"watcher_allMoney":@"gift_money"};
}

@end
