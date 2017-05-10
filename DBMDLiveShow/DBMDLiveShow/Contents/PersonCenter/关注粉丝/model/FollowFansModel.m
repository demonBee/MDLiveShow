//
//  FollowFansModel.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "FollowFansModel.h"

@implementation FollowFansModel
//解决关键字冲突
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"ID": @"id"};
}
@end
