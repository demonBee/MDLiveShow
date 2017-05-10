//
//  FollowFansModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowFansModel : NSObject

@property(nonatomic,strong)NSString*ID;  //这个人的id
@property(nonatomic,strong)NSString*Photo;  //这个人的头像
@property(nonatomic,strong)NSString*nick;   //这个人的昵称
@property(nonatomic,strong)NSString*ownFans;  //这个人拥有的粉丝
@property(nonatomic,strong)NSString*isFollow;  //1为已关注  0为未关注

@end


//{
//    Photo = "http://api.zhiboquan.net//Public/Upload/qrcode/3.jpg";
//    id = 8;
//    isFollow = 1;
//    nick = trurtur;
//    ownFans = 1;
//},
