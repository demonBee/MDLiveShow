//
//  GiveGiftView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "GiveGiftView.h"
#import "TopImageButton.h"
#import "GiftModel.h"

@interface GiveGiftView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView*mainView;   //主要的显示面板

@property(nonatomic,strong)NSString*anchor_id;  //送礼物 主播的id
@property(nonatomic,strong)NSMutableArray*allDatasModel;  //保存所有礼物的model
@property(nonatomic,strong)UILabel*bottomLabel;  //底部余额的label

@end


@implementation GiveGiftView

-(instancetype)initWithGiveAnthorID:(NSString*)idd andmainViewFrame:(CGRect)frame andSuperView:(UIView*)superView{
    self=[super init];
    if (self) {
        self.anchor_id=idd;
        
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
        
        
       
        
    }
    
    return self;
}

//给 这个选择框赋值
-(void)changeMainView{
    //移除所有的view
    for (UIView*view in [self.mainView subviews]) {
        [view removeFromSuperview];
    }
    
    
    if (self.allDatasModel.count>0&&self.allDatasModel.count<6) {
        CGFloat buttonWith=KScreenWidth/3;
        CGFloat buttonHeight=(190-30)/2;
        
       
        
        for (int i=0; i<self.allDatasModel.count; i++) {
            NSInteger hang=(i/3);
            NSInteger lie=(i%3);
            TopImageButton*topButton=[[TopImageButton alloc]initWithFrame:CGRectMake(lie*buttonWith, hang*buttonHeight, buttonWith, buttonHeight)];
            topButton.tag=i;
            [topButton addTarget:self action:@selector(clickGiveGift:)];
             GiftModel*model=_allDatasModel[topButton.tag];
            [topButton.TopImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"]];
            topButton.BottomLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L%@ %@珍珠", nil),model.title,model.price];
            
            [self.mainView addSubview:topButton];
            
            
            
        }
        
        //显示余额的label
        UILabel*bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, self.mainView.height-25, KScreenWidth/2, 20)];
        bottomLabel.textColor=[UIColor whiteColor];
        bottomLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L余额：%@珍珠", nil),[UserSession instance].user_info.CurrencyNumber];
        [self.mainView addSubview:bottomLabel];
        self.bottomLabel=bottomLabel;
        
        
        
    }else{
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L礼物最多显示6个", nil)];
        
    }
    
    
}


-(void)show{
     [self getDatas];
    
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

//点击送礼物
-(void)clickGiveGift:(TopImageButton*)sender{
    MyLog(@"直接送礼物");
    GiftModel*model=_allDatasModel[sender.tag];
    
    //送礼物
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_sendGift];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":self.anchor_id,@"gift_type":model.idd,@"gift_nums":@"1"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue] ==0) {
            [JRToast showWithText:data[@"msg"]];
            [UserSession instance].user_info.CurrencyNumber=data[@"data"];
            //需要刷新
            [self changeMainView];
            
            //礼物送成功了   需要弹幕这里有显示
            NSDictionary*dict=@{@"nick":[UserSession instance].user_info.nick,@"gift":model.title};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"giftNotification" object:nil userInfo:dict];
            
            
            
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



-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GetGift];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [self.allDatasModel removeAllObjects];
            for (NSDictionary*dict in data[@"data"]) {
                GiftModel*model=[GiftModel yy_modelWithDictionary:dict];
                [self.allDatasModel addObject:model];
            }
            
            
            [self changeMainView];
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
    }];
    
    
}


#pragma mark  --set
-(NSMutableArray *)allDatasModel{
    if (!_allDatasModel) {
        _allDatasModel=[NSMutableArray array];
    }
    return _allDatasModel;
}

@end
