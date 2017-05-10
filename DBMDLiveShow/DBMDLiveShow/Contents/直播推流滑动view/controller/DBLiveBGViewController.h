//
//  DBLiveBGViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/13.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"


//两个类型的区别   1. 退出时候不一样。    2. 多了个设置按钮和他的功能。
typedef NS_ENUM(NSInteger,LiveRoomType){
    LiveRoomTypeWatch=0,
    LiveRoomTypeShow
    
};



@interface DBLiveBGViewController : UIViewController
//创建
-(instancetype)initWithDatas:(NewPersonInfoModel*)liveItem andliveType:(LiveRoomType)liveType andSuperVC:(UIViewController*)superVC;
//两种类型推流和看直播 就几个功能不一样
@property(nonatomic,assign)LiveRoomType liveType;
@property(nonatomic,weak)UIViewController*superVC;

//这个model里面 是关于这个直播间的model1   这个单独吊用
@property (nonatomic, strong) NewPersonInfoModel *liveItem;




@end
