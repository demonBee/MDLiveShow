//
//  endShowModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/18.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface endShowModel : NSObject
@property(nonatomic,strong)NSString*anchor_time;  //直播时间（小时）
@property(nonatomic,strong)NSString*my_fans;     //我现在的关注(最新的需要减去之前的粉丝关注)
@property(nonatomic,strong)NSString*addMoneyStr;    //新增加的马币
@property(nonatomic,strong)NSString*online_nums; // 最高在线




@end
