//
//  taskView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "taskView.h"
#import "TopImageButton.h"
@interface taskView()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView*mainView;   //主要的显示面板

@end
@implementation taskView

-(instancetype)initWithGiveAnthorID:(NSString*)idd andmainViewFrame:(CGRect)frame andSuperView:(UIView*)superView{
    self=[super init];
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
        
        
        [self addButton];
        
    }
    
    return self;
}

-(void)addButton{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth-200)/2, 20, 200, 30)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"日常任务";
    [self.mainView addSubview:titleLabel];
    
    TopImageButton*topButton=[[TopImageButton alloc]initWithFrame:CGRectMake(20, 60, KScreenWidth/4, 100)];
    topButton.TopImageView.image=[UIImage imageNamed:@"每日签到"];
    topButton.BottomLabel.text=@"每日签到";
    [topButton addTarget:self action:@selector(clickTask)];
    [self.mainView addSubview:topButton];
    
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


#pragma mark  -- touch
-(void)clickTap:(UITapGestureRecognizer*)tap{
 
    [self hidden];
    
    
    
    
}


//每日签到
-(void)clickTask{
    MyLog(@"每日签到");
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SignTo];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"type":@"1"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] integerValue]==0) {
            
             [JRToast showWithText:data[@"msg"]];
              [UserSession instance].user_info.CurrencyNumber=data[@"data"];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self hidden];
    }];
    
    
    
}


#pragma mark  --delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
    
}

@end
