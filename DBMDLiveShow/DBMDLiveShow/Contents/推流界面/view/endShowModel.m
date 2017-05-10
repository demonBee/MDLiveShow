//
//  endShowModel.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/18.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "endShowModel.h"

@implementation endShowModel
//解决关键字冲突
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"addMoneyStr": @"new_gift_money"};
}
@end
