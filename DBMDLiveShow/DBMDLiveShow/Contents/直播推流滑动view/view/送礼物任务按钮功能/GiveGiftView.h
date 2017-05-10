//
//  GiveGiftView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiveGiftView : UIView
-(void)show;    //显示
-(void)hidden;   //隐藏


//这个观看直播是主播的id   自己直播也是自己主播的id
-(instancetype)initWithGiveAnthorID:(NSString*)idd andmainViewFrame:(CGRect)frame andSuperView:(UIView*)superView;


@end
