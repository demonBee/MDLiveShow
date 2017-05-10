//
//  SetBeautyView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetBeautyView : UIView

+(instancetype)creatBeautyViewWithSuperView:(UIView*)superView;

-(void)hidden;
-(void)show;

@property(nonatomic,copy)void(^switchBlock)(BOOL isOn);
@property(nonatomic,copy)void(^FirstSliderBlock)(CGFloat value);
@property(nonatomic,copy)void(^SecondSliderBlock)(CGFloat value);
@property(nonatomic,copy)void(^ThirdSliderBlock)(CGFloat value);
@end
