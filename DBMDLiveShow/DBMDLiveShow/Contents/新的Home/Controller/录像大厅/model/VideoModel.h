//
//  VideoModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject


//录像   首页录像（2筛选）  我的录像    酒店录像   字段就这些    别搞混
@property(nonatomic,strong)NSString*anchor_history_time;  //录像的时长   00:00:00
@property(nonatomic,strong)NSString*anchor_id;  //主播id
@property(nonatomic,strong)NSString*anchor_name;  //主播名字
@property(nonatomic,strong)NSString*room_name;   //房间名
@property(nonatomic,strong)NSString*snapshot_img;  //录像的封面
@property(nonatomic,strong)NSString*start_time;  //录制时间   yy：MM:DD:hh:mm:ss
@property(nonatomic,strong)NSString*url;  //这条录像的地址
@property(nonatomic,strong)NSString*video_nums;  //这个主播有多少录像
@property(nonatomic,strong)NSString*anchor_portrait;  //主播的肖像
@property(nonatomic,strong)NSString*video_likes;   //点赞量

//新增
@property(nonatomic,strong)NSString*VideoZanNumber;   //有多少个赞
@property(nonatomic,strong)NSString*video_id;   //video的 id











//{
//    VideoZanNumber = 0;
//    "anchor_history_time" = 45;
//    "anchor_id" = 3;
//    "anchor_name" = "w\U4e9a\U7d22";
//    "anchor_portrait" = "http://api.zhiboquan.net/Public/Upload/20170410/14917909792094.png";
//    "is_sign" = 1;
//    "room_name" = "\U56fd\U670d\U6700\U6709\U724c\U9762\U4e0a\U5355";
//    "sign_time" = 1498038285;
//    "snapshot_img" = "http://ojnoo5stt.bkt.clouddn.com/mdzb_3-3953448769636293621.jpg";
//    "start_time" = 1498027047;
//    "top_time" = 1498034233;
//    url = "http://ojnoo5stt.bkt.clouddn.com/recordings/z1.zhibojian11.mdzb_3/1498027047_1498027091.m3u8";
//    "video_id" = 210;
//    "video_likes" = 0;
//    "video_nums" = 10;
//},


@end
