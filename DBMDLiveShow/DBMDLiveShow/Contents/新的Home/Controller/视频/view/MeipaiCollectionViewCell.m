//
//  MeipaiCollectionViewCell.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MeipaiCollectionViewCell.h"

@implementation MeipaiCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImageView.userInteractionEnabled=YES;
    self.mainImageView.backgroundColor=[UIColor blackColor];
     self.mainImageView.contentMode=UIViewContentModeScaleAspectFill;
    
     self.deleteButton.hidden=YES;
    
    [self.zanButton setTitle:@"0"];
    self.zanButton.titleLabel.font=[UIFont systemFontOfSize:10];
    self.zanButton.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    [self.zanButton setImage:@"zanLove"];
    self.zanButton.imageEdgeInsets=UIEdgeInsetsMake(5,0, 5, 35);
    
    [self.locationButton setTitle:@"0"];
    self.locationButton.titleLabel.font=[UIFont systemFontOfSize:10];
//    self.locationButton.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    [self.locationButton setImage:@"room_window_profile_location"];
//    self.locationButton.imageEdgeInsets=UIEdgeInsetsMake(0,0, 0, 10);

    self.photoImage.layer.cornerRadius=25/2;
    self.photoImage.layer.masksToBounds=YES;
    
}


-(void)setMainModel:(MeiPaiHomeModel *)mainModel{
    _mainModel=mainModel;
    
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.snapshot_img] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:nil];
    
    [self.locationButton setTitle:mainModel.location];
    
    
    self.titleLabel.text=mainModel.title;
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:mainModel.header_img] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:nil];
    
    self.nameLabel.text=mainModel.nickname;
    
    [self.zanButton setTitle:mainModel.meipai_likes];

}

- (IBAction)clickZan:(id)sender {
    UIButton*button=sender;
    button.enabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled=YES;
        
    });
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MeiPaiZan];
    
    
    NSDictionary*params=@{@"user_id":[UserSession instance].user_id,@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"meipai_id":self.mainModel.meipai_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //成功了
            [JRToast showWithText:data[@"msg"]];
            NSInteger number=[_mainModel.meipai_likes integerValue]+1;
            [self.zanButton setTitle:[NSString stringWithFormat:@"%lu",number]];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    

    
    
    
    
}

- (IBAction)clickDeleteButton:(id)sender {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock();
    }

    
    
    
}
@end
