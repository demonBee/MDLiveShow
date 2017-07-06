//
//  DBShowInfoView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBShowInfoView.h"
#import "DBReportViewController.h"

@interface DBShowInfoView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainVIew;

@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;



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

@property(nonatomic,weak)UIView*superView;
@end

@implementation DBShowInfoView

+(instancetype)showInfoViewInView:(UIView*)superView{
    DBShowInfoView*pageView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    pageView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    pageView.superView=superView;
    [superView addSubview:pageView];

    
    
    return pageView;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
//    self.mainVIew.width=ACTUAL_WIDTH(302);
//    self.mainVIew.height=ACTUAL_HEIGHT(410);

}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.reportButton setTitle:DBGetStringWithKeyFromTable(@"L举报", nil)];
    [self.blackButton setTitle:DBGetStringWithKeyFromTable(@"L拉黑", nil)];
    [self.redButton setTitle:DBGetStringWithKeyFromTable(@"L禁言", nil)];
    
     self.hidden=YES;
    self.mainVIew.hidden=YES;
    self.backgroundColor=[UIColor colorWithWhite:0.4 alpha:0.4];
    self.mainVIew.transform=CGAffineTransformMakeScale(0.1, 0.1);
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageViewHidden:)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];

    
}


-(void)show{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.hidden=NO;
        self.mainVIew.hidden=NO;
        self.mainVIew.transform=CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

-(void)hidden{
    [UIView animateWithDuration:0.5 animations:^{
        self.mainVIew.transform=CGAffineTransformMakeScale(0.1, 0.1);
        
        
    } completion:^(BOOL finished) {
        self.mainVIew.hidden=YES;
        self.hidden=YES;
        
    }];
    
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainVIew]) {
        return NO;
    }else{
        return YES;
    }
    
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
    
    
    self.blackButton.hidden=NO;
    if (self.isLiverTouch) {
        self.redButton.hidden=NO;
    }else{
        self.redButton.hidden=YES;
    }
    
    
    self.letterButton.hidden=YES;
    self.artButton.hidden=YES;
    self.homePage.hidden=YES;
}




#pragma mark  --touch
-(void)pageViewHidden:(UIGestureRecognizer*)tap{
    [self hidden];
    
}

- (IBAction)cancel:(id)sender {
    [self hidden];
    
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
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_RY_addBlack];
    NSDictionary*headerDic=[HttpObject getRYRequestHeader];
//
    NSDictionary*params=@{@"userId":[UserSession instance].user_id,@"blackUserId":self.mainModel.ID};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataAndRequestHeaderNoHudWithUrl:urlStr parameters:params andRequestHeader:headerDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);

        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"拉黑成功，您将看不到对方的信息"];
            
        }else{
            [JRToast showWithText:@"拉黑失败..."];
        }
        
        
        
        
        
    }];
    
    
    
}
- (IBAction)Shutup:(id)sender {
    //禁言
    if (!self.isLiverTouch) {
        return;
        
    }
    
//    DBSelf(weakSelf);
//    NSString*aa=[NSString stringWithFormat:@"你确实要禁言%@",self.mainModel.nick];
//    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"禁言" message:aa preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//      UITextField*textField=alertVC.textFields.firstObject;
//        NSString*timeLong=textField.text;
//        if (timeLong.length<2) {
//            [JRToast showWithText:@"时间输入错误"];
//        }
//        [weakSelf JinyanDatasWithTimeLong:timeLong];
//        
//        
//        
//        
//        
//    }];
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder=@"请输入禁言时长(分)";
//        textField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
//        
//    }];
//    [alertVC addAction:cancel];
//    [alertVC addAction:sure];
//    UIViewController*superVC=[DBTools getSuperViewWithsubView:self.superView];
//    [superVC presentViewController:alertVC animated:YES completion:nil];
    
    
    [self JinyanDatasWithTimeLong:@"1440"];
    
    
    
    
    
}


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



#pragma mark  -- getDatas
//禁言接口
-(void)JinyanDatasWithTimeLong:(NSString*)timeLong{
    
    if ([[UserSession instance].user_id isEqualToString:self.mainModel.ID]) {
        [JRToast showWithText:@"不能禁言自己"];
        return;
    }
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_RY_addgag];
    NSDictionary*headerDic=[HttpObject getRYRequestHeader];
    //    self.mainModel.ID
    NSDictionary*params=@{@"userId":self.mainModel.ID,@"chatroomId":[UserSession instance].user_id,@"minute":timeLong};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataAndRequestHeaderNoHudWithUrl:urlStr parameters:params andRequestHeader:headerDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"对方已被禁言一天"];
            
        }else{
            [JRToast showWithText:@"禁言失败..."];
        }
        
        
        
        
        
    }];

    
}



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

-(void)setIsLiverTouch:(BOOL)isLiverTouch{
    _isLiverTouch=isLiverTouch;
    if (self.isLiverTouch) {
        self.redButton.hidden=NO;
    }else{
        self.redButton.hidden=YES;
    }

    
}


@end
