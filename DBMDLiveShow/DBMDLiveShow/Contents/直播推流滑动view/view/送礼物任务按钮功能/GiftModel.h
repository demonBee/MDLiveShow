//
//  GiftModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject
//礼物模板
@property(nonatomic,strong)NSString*idd;  // 这个礼物椰子是1   从1开始的  
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*photo;  //图片？

@end
