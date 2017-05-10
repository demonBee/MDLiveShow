//
//  SetPushView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

//这个是自己直播间独有的   送礼 签到 和 分享都是通用的

#import <UIKit/UIKit.h>
#import "TopImageButton.h"
@interface SetPushView : UIView

-(void)show;    //显示
-(void)hidden;   //隐藏


//这个观看直播是主播的id   自己直播也是自己主播的id
-(instancetype)initWithmMainViewFrame:(CGRect)frame andSuperView:(UIView*)superView;


@property(nonatomic,strong)void(^clickFundationBlock)(NSInteger number);

@end
