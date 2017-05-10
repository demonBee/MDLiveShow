//
//  SetPushView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SetPushView.h"

@interface SetPushView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView*mainView;   //主要的显示面板


@end
@implementation SetPushView


-(instancetype)initWithmMainViewFrame:(CGRect)frame andSuperView:(UIView*)superView{
     self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.1];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        self.hidden=YES;
        [superView addSubview:self];

        
        
        self.mainView=[[UIView alloc]init];
        if (CGRectEqualToRect(frame, CGRectZero)) {
            self.mainView.frame=CGRectMake(0, KScreenHeight, KScreenWidth, 190);
        }else{
            self.mainView.frame=frame;
        }
        self.mainView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:1.0];
        [self addSubview:self.mainView];
        self.hidden=YES;

        
        
        for (int i=0; i<4; i++) {
            CGFloat buttonWithHeight=(KScreenWidth-5*20)/4;
            TopImageButton*button=[[TopImageButton alloc]initWithFrame:CGRectMake(20+(20+buttonWithHeight)*i, 20, buttonWithHeight, buttonWithHeight)];
            button.tag=i+100;
            [button addTarget:self action:@selector(clickButton:)];
            [self.mainView addSubview:button];
            
            
            switch (button.tag) {
                case 100:{
                    button.TopImageView.image=[UIImage imageNamed:@"静音1"];
                    button.BottomLabel.text=DBGetStringWithKeyFromTable(@"L静音", nil);
                    break;}
                case 101:{
                    button.TopImageView.image=[UIImage imageNamed:@"镜头翻转1"];
                    button.BottomLabel.text=DBGetStringWithKeyFromTable(@"L翻转镜头", nil);
                    break;}
                case 102:{
                    button.TopImageView.image=[UIImage imageNamed:@"缩放1"];
                    button.BottomLabel.text=DBGetStringWithKeyFromTable(@"L镜头缩放", nil);
                    break;}
                case 103:{
                    button.TopImageView.image=[UIImage imageNamed:@"美颜1"];
                    button.BottomLabel.text=DBGetStringWithKeyFromTable(@"L美颜", nil);
                    break;}
                    
                default:
                    break;
            }
        }

        
    }
    return self;
    
    
}


-(void)show{
    self.hidden=NO;
    self.mainView.hidden=NO;
    CGRect resultRect= CGRectMake(0, KScreenHeight-self.mainView.height, KScreenWidth, self.mainView.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame=resultRect;
        
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

-(void)hidden{
    CGRect resultRect=CGRectMake(0, KScreenHeight, KScreenWidth, self.mainView.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame=resultRect;
        
    } completion:^(BOOL finished) {
        self.mainView.hidden=YES;
        self.hidden=YES;
        
    }];
    
}


-(void)clickTap:(UITapGestureRecognizer*)tap{
    [self hidden];
    
    
    
}


#pragma mark  --delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
    
}


#pragma mark  --touch
-(void)clickButton:(TopImageButton*)sender{
    switch (sender.tag) {
        case 100:{
//                       button.BottomLabel.text=@"静音";
             [self hidden];
            self.clickFundationBlock(sender.tag-100);
            break;}
        case 101:{
//                       button.BottomLabel.text=@"翻转镜头";
              self.clickFundationBlock(sender.tag-100);
            break;}
        case 102:{
           
//            button.BottomLabel.text=@"镜头缩放";
            [self hidden];
              self.clickFundationBlock(sender.tag-100);
            break;}
        case 103:{
         
//            button.BottomLabel.text=@"美颜";
             [self hidden];
              self.clickFundationBlock(sender.tag-100);
            break;}
            
        default:
            break;
    }

    
    
}


@end
