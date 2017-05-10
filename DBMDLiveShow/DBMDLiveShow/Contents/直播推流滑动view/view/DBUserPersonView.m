//
//  DBUserPersonView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBUserPersonView.h"
#import "DBReportViewController.h"

@interface DBUserPersonView()
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIButton *payLevel;
@property (weak, nonatomic) IBOutlet UIButton *showLevel;
@property (weak, nonatomic) IBOutlet UILabel *roomNumber;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet UILabel *attentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGetLabel;



@property (weak, nonatomic) IBOutlet UIButton *attentButton;
@property (weak, nonatomic) IBOutlet UIButton *letterButton;
@property (weak, nonatomic) IBOutlet UIButton *artButton;
@property (weak, nonatomic) IBOutlet UIButton *homePage;

//我 是否关注了这个人
@property(nonatomic,assign)BOOL isAttention;

@end

@implementation DBUserPersonView

+ (instancetype)creatDBUserPersonView{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}



-(void)setMainModel:(NewPersonInfoModel *)mainModel{
    _mainModel=mainModel;
    
    self.bigImageView.layer.cornerRadius=self.bigImageView.width/2;
    self.bigImageView.layer.masksToBounds=YES;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.nickLabel.text=mainModel.nick;
    
    if ([mainModel.gender isEqualToString:@"m"]) {
        self.sexImageView.image=[UIImage imageNamed:@"icon_pc_male"];
    }else{
        self.sexImageView.image=[UIImage imageNamed:@"icon_pc_female"];
    }
    
    [self.payLevel setTitle:mainModel.watcherLevel];
    
    [self.showLevel setTitle:mainModel.LiveLevel];
    
    self.roomNumber.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L房间号:%@", nil),mainModel.roomid];
    
    if (!mainModel.city) {
        self.placeLabel.text=DBGetStringWithKeyFromTable(@"L猩球", nil);
    }else{
        self.placeLabel.text=mainModel.city;
    }
    
    self.markLabel.text=mainModel.signature;
    
    
    self.attentLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L关注:%@", nil),mainModel.attentionNumber];
    self.fansLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L粉丝:%@", nil),mainModel.fansNumber];
    self.totalLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L消费:%@", nil),mainModel.totailPayMoney];
    self.totalGetLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L收益:%@", nil),mainModel.totailLiveGetMoney];
    
    [self.attentButton setTitle:DBGetStringWithKeyFromTable(@"L关注", nil) forState:UIControlStateNormal];
     [self.attentButton setTitle:DBGetStringWithKeyFromTable(@"L取关", nil) forState:UIControlStateSelected];
    [self.attentButton addTarget:self action:@selector(ClickAttent:)];

    
    //得到用户和主播的关系 并显示按钮
    [self getUserWithAnchorRelation];

    
    
    
    [self.letterButton setSelected:NO];
    
    
    [self.artButton setSelected:NO];
    
    [self.homePage setSelected:NO];
    
    
    self.blackButton.hidden=YES;
    
    self.letterButton.hidden=YES;
    self.artButton.hidden=YES;
    self.homePage.hidden=YES;
}




#pragma mark  -- getDatas
//得到用户和主播的关系
-(void)getUserWithAnchorRelation{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_UserAndAnchorRelation];
    NSDictionary*params=@{@"user_id":[UserSession instance].user_id,@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"anchor_id":self.mainModel.ID};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            if ([data[@"data"][@"isFollow"] integerValue]==1) {
                self.isAttention=YES;
                
            }else{
                self.isAttention=NO;
            }
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        // 如果点击了关注 并且成功了 那么需要隐藏按钮
        if (self.isAttention==YES) {
            [self.attentButton setSelected:YES];
        }else{
            [self.attentButton setSelected:NO];
        }
        
        
        
    }];
    
    
};




#pragma mark  --touch
-(void)ClickAttent:(UIButton*)sender{
    BOOL isSelected=sender.selected;
    NSString*isLike;
    if (!isSelected) {
        isLike=@"1";
    }else{
        isLike=@"0";
    }
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_FOllowOrCancelFollow];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":_mainModel.ID,@"is_like":isLike};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //成功了
            [JRToast showWithText:data[@"data"]];
            if ([isLike isEqualToString:@"1"]) {
                sender.selected=YES;
//                _mainModel.isFollow=@"1";
                _isAttention=YES;
                
            }else{
                sender.selected=NO;
//                _mainModel.isFollow=@"0";
                _isAttention=NO;
                
                
            }
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            if (self.closeViewBlock) {
                self.closeViewBlock();
            }
            
            
        }
        
        
    }];
    
    
}



- (IBAction)cancel:(id)sender {
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
    
}

- (IBAction)report:(id)sender {
//举报
    DBReportViewController*reportVC=[[DBReportViewController alloc]init];
    reportVC.mainModel=self.mainModel;
    self.hidden=YES;
    UIViewController*superVC=[self viewController];
    [superVC.navigationController pushViewController:reportVC animated:YES];

}


- (IBAction)ToBlack:(id)sender {
//拉黑
    
}


#pragma mark  -- function
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
