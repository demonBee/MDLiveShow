//
//  RCLikeMessage.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

#define RCDLiveGiftMessageIdentifier @"RC:GiftMsg"
/* 点赞消息
 *
 * 对于聊天室中发送频率较高，不需要存储的消息要使用状态消息，自定义消息继承RCMessageContent 
 * 然后persistentFlag 方法返回 MessagePersistent_STATUS
 */
@interface RCDLiveGiftMessage : RCMessageContent

/*
 * 类型 0 小花，1，鼓掌
 */
@property(nonatomic, strong) NSString *type;


//礼物  100个椰子  1贝壳  2珊瑚  3鲨鱼  4游艇       就用这个string 代表着某种礼物中文的

@property(nonatomic,strong)NSString*giftType;
//文字组织好了
@property(nonatomic,strong)NSString*titleStr;







//礼物的图片地址
@property(nonatomic,strong)NSString*giftImageStr;
//礼物的名字
@property(nonatomic,strong)NSString*giftName;


@end
