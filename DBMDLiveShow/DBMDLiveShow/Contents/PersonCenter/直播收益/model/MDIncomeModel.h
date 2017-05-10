//
//  PresentRecordModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDIncomeModel : NSObject

@property(nonatomic,strong)NSString*monthDay;        //月和天
@property(nonatomic,strong)NSString*hourMin;        //小时 分钟
@property(nonatomic,strong)NSString*WhoPayPhoto;   //谁赠送的人的头像
@property(nonatomic,strong)NSString*WhoPayNick;   //谁赠送的名字
@property(nonatomic,strong)NSString*giftName;    //礼物的名字
@property(nonatomic,strong)NSString*giftMB;   //礼物值多少马币


@end
