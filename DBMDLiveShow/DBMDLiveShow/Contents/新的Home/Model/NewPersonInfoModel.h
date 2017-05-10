//
//  NewPersonInfoModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewPersonInfoModel : NSObject

/** ID号 房间号,就是个人信息model 里面的id*/
@property (nonatomic, strong) NSString*ID;
/** 直播流地址 */
@property (nonatomic, copy) NSString *stream_addr;
/**当前的人数 */
@property (nonatomic, strong) NSString* online_users;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 直播间名称*/
@property (nonatomic, copy) NSString *room_name;
//房间号  6位靓号
@property(nonatomic,strong)NSString*roomid;
//当前时间 如 2017.4.14
@property(nonatomic,strong)NSString*currentTime;
//当前是否正在直播  0没有在直播  1正在直播
@property(nonatomic,strong)NSString*isliving;



/** 主播名,用户的名字 */
@property (nonatomic, strong) NSString *nick;
/** 主播头像，用户的头像 */
@property (nonatomic, strong) NSString *portrait;
//年龄
@property(nonatomic,strong)NSString*age;
/** 该用户的性别  返回m或者fm*/
@property (nonatomic, strong) NSString *gender;
//主播的直播间等级
@property(nonatomic,strong)NSString*LiveLevel;
//观众消费等级
@property(nonatomic,strong)NSString*watcherLevel;
//总的打赏消费金额
@property(nonatomic,strong)NSString*totailPayMoney;
//作为主播总的赚的钱
@property(nonatomic,strong)NSString*totailLiveGetMoney;
//个信签名  mark 改的
@property (nonatomic, strong) NSString*signature;
//关注人数
@property (nonatomic, strong) NSString*attentionNumber;
//粉丝人数
@property (nonatomic, strong) NSString*fansNumber;
//直播时长  保留一位小时
@property (nonatomic, strong) NSString*liveTimer;
//当前马币数量，保留一位小时 1马币等于1RMB
@property (nonatomic, strong) NSString*CurrencyNumber;

@property(nonatomic,strong)NSString*phoneNumber;   //新增的电话号码  没有就是@“”

//新增当前的主播实名认证状态        //是否实名认证 0未认证（能播，能实名认证） 1申请中（能播，不能实名认证）   2已认证（能播，不能实名认证）  3拒绝（不能播，能实名认证）  4禁播（不能播，不能实名认证）
@property(nonatomic,strong)NSString*is_real;
//很重要。。    当user_id（必传） anchor_id也传的时候  来判断（user_id有没有关注anchor_id）  如果没有anchor_id 那么为0      包括主播的anchor_id这个模板中  也是用户（user_id）相对于这个主播是否关注     已知的接口
//@property(nonatomic,strong)NSString*isFollow;   //0为未关注  1为已关注


@end
