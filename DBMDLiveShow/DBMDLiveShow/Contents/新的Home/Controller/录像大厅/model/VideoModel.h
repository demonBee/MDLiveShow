//
//  VideoModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property(nonatomic,strong)NSString*anchor_history_time;  //录像的时间   00:00:00
@property(nonatomic,strong)NSString*anchor_id;  //主播id
@property(nonatomic,strong)NSString*anchor_name;  //主播名字
@property(nonatomic,strong)NSString*room_name;   //房间名
@property(nonatomic,strong)NSString*snapshot_img;  //录像的封面
@property(nonatomic,strong)NSString*start_time;  //录制时间   yy：MM:DD:hh:mm:ss
@property(nonatomic,strong)NSString*url;  //这条录像的地址
@property(nonatomic,strong)NSString*video_nums;  //这个主播有多少录像

//新增
@property(nonatomic,strong)NSString*anchor_portrait;  //主播的肖像







@end
