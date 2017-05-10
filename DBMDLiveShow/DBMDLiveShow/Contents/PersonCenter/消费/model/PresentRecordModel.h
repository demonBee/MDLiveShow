//
//  PresentRecordModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentRecordModel : NSObject

@property(nonatomic,strong)NSString*monthDay;        //月和天
@property(nonatomic,strong)NSString*hourMin;        //小时 分钟
@property(nonatomic,strong)NSString*PayForAnchorPhoto;   //赠送给主播的头像
@property(nonatomic,strong)NSString*PayForAnchorNick;   //赠送给主播的名字
@property(nonatomic,strong)NSString*giftName;    //礼物的名字
@property(nonatomic,strong)NSString*giftMB;   //礼物值多少马币


@end
