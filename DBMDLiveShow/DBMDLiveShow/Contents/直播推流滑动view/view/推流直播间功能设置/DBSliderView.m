//
//  DBSliderView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBSliderView.h"

@interface DBSliderView()<UIGestureRecognizerDelegate>
@property(nonatomic,assign)sliderType Stype;
@property(nonatomic,strong)UIView*mainView;
@property(nonatomic,strong)UISlider*slider;

@end

@implementation DBSliderView

-(instancetype)initWithType:(sliderType)type andsuperView:(UIView*)superView andMaxValue:(CGFloat)maxValue{
    self=[super init];
    if (self) {
        _Stype=type;
        
        self.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.backgroundColor=[UIColor colorWithWhite:0.4 alpha:0.4];
        self.hidden=YES;
        [superView addSubview:self];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBGHidden)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];

        
        _mainView=[[UIView alloc]init];
        _mainView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.mainView];
        
        UISlider *slider = [[UISlider alloc] init];
        self.slider=slider;
        [_mainView addSubview:slider];
        
        if (self.Stype==sliderTypePhoto) {
            slider.value = 1.0;
            slider.minimumValue = 1.0;
            slider.maximumValue = MIN(5,maxValue);

        }else{
            slider.value=0.5;
            slider.minimumValue = 0.0;
            slider.maximumValue =1.0;
        }
        
        
        [slider addTarget:self action:@selector(scrollSlider:) forControlEvents:UIControlEventValueChanged];

        
    }
    
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.offset(KScreenWidth);
        make.height.offset(100);

        
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.mainView.center);
        make.width.offset(320);
        make.height.offset(20);
        
    }];
    
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
}

-(void)clickBGHidden{
    [self hidden];
    
}


-(void)show{
    self.hidden=NO;
    
}
-(void)hidden{
    self.hidden=YES;
    
}



-(void)scrollSlider:(UISlider*)slider{
    if (self.slideBlock) {
        self.slideBlock(slider);
    }
    
    
}

#pragma mark  --set


@end
