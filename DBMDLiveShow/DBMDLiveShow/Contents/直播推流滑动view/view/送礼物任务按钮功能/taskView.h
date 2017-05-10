//
//  taskView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface taskView : UIView

-(void)show;    //显示
-(void)hidden;   //隐藏

//这里的id 貌似用不到  反正都是自己的idd
-(instancetype)initWithGiveAnthorID:(NSString*)idd andmainViewFrame:(CGRect)frame andSuperView:(UIView*)superView;

@end
