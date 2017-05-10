//
//  ShowLiveResultView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ShowLiveResultView.h"


@implementation ShowLiveResultView

+(instancetype)creatResultViewWith:(NewPersonInfoModel*)model{
    ShowLiveResultView*resultView= [[NSBundle mainBundle]loadNibNamed:@"ShowLiveResultView" owner:nil options:nil].firstObject;
    resultView.mainModel=model;
    resultView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    resultView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.9];

    [resultView setupUI];
    
    return resultView;
    
}


-(void)setupUI{
    [self getDatas];
   
    
}


-(void)reloadDatas{

    
    self.liveTimeLabel.text=self.endModel.anchor_time;
    self.livePersonNumberLabel.text=self.endModel.online_nums;
    self.addMBLabel.text=self.endModel.addMoneyStr;
    
    
    CGFloat old=[self.mainModel.fansNumber floatValue];
    CGFloat new=[self.endModel.my_fans floatValue];
    CGFloat addFans=new-old;
    self.addAttentionLabel.text=[NSString stringWithFormat:@"%.0f",addFans];
    
    
}


#pragma mark  -- touch
- (IBAction)clickCancelBtn:(id)sender {
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark  --datas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_endLive];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"anchor_id":self.mainModel.ID,@"user_id":self.mainModel.ID};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            NSDictionary*dict=data[@"data"];
            endShowModel*model=[endShowModel yy_modelWithDictionary:dict];
            self.endModel=model;
            //刷新结束直播后的 内容
            [self reloadDatas];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
}


//得到view 的父视图控制器
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
