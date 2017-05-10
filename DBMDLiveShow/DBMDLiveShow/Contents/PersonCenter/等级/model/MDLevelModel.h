//
//  MDLevelModel.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDLevelModel : NSObject
@property(nonatomic,strong)NSString*tips;  //tips

@property(nonatomic,strong)NSString*LiveLevel;  //主播等级
@property(nonatomic,strong)NSString*Live_lackmoney;   //主播距离升级所需金额
@property(nonatomic,strong)NSString*Live_totailMoney; //主播累计经验

@property(nonatomic,strong)NSString*WatcherLevel;      //观众等级
@property(nonatomic,strong)NSString*Watcher_Lackmoney;     //观众距离升级所需金额
@property(nonatomic,strong)NSString*Watcher_totailMoney;     //观众累计经验



@end



//{
//    LiveLevel = 1;
//    "Live_lackmoney" = 0;
//    "Live_totailMoney" = "<null>";
//    tips = "\U89c2\U4f17\U7b49\U7ea7100W\U7ecf\U9a8c30\U7ea7\U6ee1\U7ea7\Uff0c\U4e3b\U64ad1000W\U7ecf\U9a8c60\U7ea7\U6ee1\U7ea7";
//    watcherLevel = 1;
//    "watcher_Lackmoney" = 0;
//    "watcher_totailMoney" = "<null>";
//};






//tips = "\U89c2\U4f17\U7b49\U7ea7100W\U7ecf\U9a8c30\U7ea7\U6ee1\U7ea7\Uff0c\U4e3b\U64ad1000W\U7ecf\U9a8c60\U7ea7\U6ee1\U7ea7";

//LiveLevel = 1;
//"Live_money" = 0;
//"gift_money" = "<null>";

//"total_gift_money" = "<null>";
//watcherLevel = 1;
//"watcher_money" = 0;
