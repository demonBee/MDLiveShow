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
@property(nonatomic,strong)NSString*VideoZanNumber;   //有多少个赞
@property(nonatomic,strong)NSString*video_id;   //video的 id



//{
//    VideoZanNumber = 0;
//    "anchor_history_time" = 1493431905;
//    "anchor_id" = 39;
//    "anchor_name" = "\U5446\U840c\U5c0f\U5403\U8d27";
//    "anchor_portrait" = "http://api.zhiboquan.net/Public/Upload/20170517/14950045172279.png";
//    "room_name" = "A\U5c0f\U5c0f\U54d2\U7684\U76f4\U64ad\U95f4";
//    "snapshot_img" = "http://ojnoo5stt.bkt.clouddn.com/mdzb_39-5122577795712814114.jpg";
//    "start_time" = 0;
//    url = "http://ojnoo5stt.bkt.clouddn.com/recordings/z1.zhibojian11.mdzb_39/0_1493431904.m3u8";
//    "video_nums" = 1;
//},



@end
