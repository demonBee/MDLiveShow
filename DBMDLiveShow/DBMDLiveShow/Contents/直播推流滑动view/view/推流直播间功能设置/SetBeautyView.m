///Users/huangjiafeng/Desktop/DBMDLiveShow/DBMDLiveShow.xcodeproj
//  SetBeautyView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SetBeautyView.h"
@interface SetBeautyView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISwitch *BeautySwitch;
@property (weak, nonatomic) IBOutlet UISlider *FirstSlider;
@property (weak, nonatomic) IBOutlet UISlider *secondSlider;
@property (weak, nonatomic) IBOutlet UISlider *thirdSlider;


@end

@implementation SetBeautyView

+(instancetype)creatBeautyViewWithSuperView:(UIView *)superView{
    SetBeautyView*beautyView=[[NSBundle mainBundle]loadNibNamed:@"SetBeautyView" owner:nil options:nil].firstObject;
    beautyView.frame=CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);
    [superView addSubview:beautyView];
//    beautyView.hidden=YES;
    beautyView.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
    beautyView.mainView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
    
    [beautyView setUI];
    
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:beautyView action:@selector(touchHidden)];
    tap.delegate=beautyView;
    [beautyView addGestureRecognizer:tap];
    
    
    
    return beautyView;
}

#pragma mark  --UI
-(void)setUI{
    self.BeautySwitch.on = YES;
    self.BeautySwitch.onTintColor=KNaviColor;
    self.BeautySwitch.tintColor=[UIColor whiteColor];
    [self.BeautySwitch addTarget:self action:@selector(touchSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    self.FirstSlider.minimumValue=0.0;
    self.FirstSlider.maximumValue=1.0;
    self.FirstSlider.value=0.5;
    self.FirstSlider.continuous=NO;
    self.FirstSlider.minimumTrackTintColor=KNaviColor;
    [self.FirstSlider addTarget:self action:@selector(FirstSliderChange:) forControlEvents:UIControlEventValueChanged];

    
    self.secondSlider.minimumValue=0.0;
    self.secondSlider.maximumValue=1.0;
    self.secondSlider.value=0.5;
    self.secondSlider.continuous=NO;
    self.secondSlider.minimumTrackTintColor=KNaviColor;
    [self.secondSlider addTarget:self action:@selector(secondSliderChange:) forControlEvents:UIControlEventValueChanged];

    
    self.thirdSlider.minimumValue=0.0;
    self.thirdSlider.maximumValue=1.0;
    self.thirdSlider.value=0.5;
    self.thirdSlider.continuous=NO;
    self.thirdSlider.minimumTrackTintColor=KNaviColor;
    [self.thirdSlider addTarget:self action:@selector(thirdSliderChange:) forControlEvents:UIControlEventValueChanged];

    
}


#pragma mark  --delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
}

#pragma mark  --touch
-(void)touchHidden{
    [self hidden];
    
}


-(void)touchSwitch:(UISwitch*)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (self.switchBlock) {
        self.switchBlock(isButtonOn);
    }
    
    
    if (isButtonOn) {
        NSLog(@"开");
    }else {
        NSLog(@"关");
    }
    
}

-(void)FirstSliderChange:(UISlider*)sender{
    if (self.FirstSliderBlock) {
        self.FirstSliderBlock(sender.value);
    }
    
}

-(void)secondSliderChange:(UISlider*)sender{
    if (self.SecondSliderBlock) {
        self.SecondSliderBlock(sender.value);
    }
    
}

-(void)thirdSliderChange:(UISlider*)sender{
    if (self.ThirdSliderBlock) {
        self.ThirdSliderBlock(sender.value);
    }
    
}

#pragma mark  --function
-(void)hidden{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect startFrame=self.frame;
        startFrame.origin.y=  self.frame.origin.y+KScreenHeight;
        self.frame=startFrame;
        
    } completion:^(BOOL finished) {
       
//        [self removeFromSuperview];
    }];
    
}

-(void)show{
   
    [UIView animateWithDuration:0.5 animations:^{
        CGRect startFrame=self.frame;
        startFrame.origin.y=  self.frame.origin.y-KScreenHeight;
        self.frame=startFrame;
        
    } completion:^(BOOL finished) {
        
       
    }];

    
    
}

@end
