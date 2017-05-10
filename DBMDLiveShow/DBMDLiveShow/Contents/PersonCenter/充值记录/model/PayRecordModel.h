//
//  PayRecordModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayRecordModel : NSObject

@property(nonatomic,strong)NSString*out_trade_no;   //订单号
@property(nonatomic,strong)NSString*total_money;   //冲了多少钱
@property(nonatomic,strong)NSString*pay_time;  //充值时间
@property(nonatomic,strong)NSString*pay_method;  //充值类型



//{
//    nickname = chop;
//    "order_sn" = 1514939524531634;
//    "out_trade_no" = 1000000296294845;
//    "pay_method" = "apple\U5185\U8d2d";
//    "pay_time" = 1493952453;
//    portrait = "http://api.zhiboquan.net/Public/Upload/20170420/14926553351263.png";
//    "total_money" = "388.00";
//    "user_id" = 15;
//},

@end
