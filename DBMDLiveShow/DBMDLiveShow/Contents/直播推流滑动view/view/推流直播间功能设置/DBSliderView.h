//
//  DBSliderView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,sliderType){
    sliderTypePhoto=0,  //镜头缩放
    sliderTypeBeauty     //美颜

};

@interface DBSliderView : UIView



-(instancetype)initWithType:(sliderType)type andsuperView:(UIView*)superView andMaxValue:(CGFloat)maxValue;

@property(nonatomic,copy)void(^slideBlock)(UISlider*slider);

-(void)show;
-(void)hidden;
@end
