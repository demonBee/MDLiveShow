//
//  MeiPaiHomeModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeiPaiHomeModel : NSObject

//美拍  首页3筛选  我的美拍   酒店美拍  字段就这些
@property(nonatomic,strong)NSString*duration;
@property(nonatomic,strong)NSString*header_img;
@property(nonatomic,strong)NSString*location;
@property(nonatomic,strong)NSString*meipai_id;
@property(nonatomic,strong)NSString*meipai_likes;   //多少点赞
@property(nonatomic,strong)NSString*nickname;
@property(nonatomic,strong)NSString*send_time;
@property(nonatomic,strong)NSString*snapshot_img;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*url;
@property(nonatomic,strong)NSString*user_id;



@end



//{
//    duration = 2;
//    "header_img" = "http://api.zhiboquan.net/Public/Upload/20170410/14917909792094.png";
//    location = "";
//    "meipai_id" = 3;
//    "meipai_likes" = 0;
//    nickname = "w\U4e9a\U7d22";
//    "send_time" = 1498113331;
//    "snapshot_img" = "http://orn6y27ks.bkt.clouddn.com/short_video_20170622143456.mp4?vframe/jpg/offset/0";
//    title = "";
//    url = "http://orn6y27ks.bkt.clouddn.com/short_video_20170622143456.mp4";
//    "user_id" = 3;
//},
