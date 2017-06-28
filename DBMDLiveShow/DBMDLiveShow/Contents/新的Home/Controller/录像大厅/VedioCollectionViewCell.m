//
//  VedioCollectionViewCell.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "VedioCollectionViewCell.h"

@implementation VedioCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.BGImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.BGImageView.clipsToBounds = YES;//设置这个属性为YES就可以了，默认是NO;
    
    _anchor_photo.layer.cornerRadius=10;
    _anchor_photo.layer.masksToBounds=YES;
    self.anchor_photo.contentMode=UIViewContentModeScaleAspectFill;
    self.anchor_photo.clipsToBounds=YES;
    
    self.CoverView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    
    [self.zanButton setTitle:@"0"];
    self.zanButton.titleLabel.font=[UIFont systemFontOfSize:10];
    self.zanButton.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    [self.zanButton setImage:@"zanLove"];
    self.zanButton.imageEdgeInsets=UIEdgeInsetsMake(5,0, 5, 25);
    
    self.deleteButton.hidden=YES;
    
}



-(void)setMainModel:(VideoModel *)mainModel{
    _mainModel=mainModel;
    
    [self.zanButton setTitle:mainModel.VideoZanNumber];
    
  [self.BGImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.snapshot_img] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      
  }];
    
    [self.anchor_photo sd_setImageWithURL:[NSURL URLWithString:mainModel.anchor_portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.anchor_nick.text=mainModel.anchor_name;
    
    NSString*timeLong=[DBTools TimeLongFormat:mainModel.anchor_history_time];
    NSString*timeStart=[DBTools TimeStartFormat:mainModel.start_time];
    self.timeLongLabel.text=[NSString stringWithFormat:@"时长:%@",timeLong];
    self.timeLabel.text=[NSString stringWithFormat:@"时间:%@",timeStart];
    self.roomName.text=mainModel.room_name;
    
}


//点赞
- (IBAction)clickZan:(id)sender {
    UIButton*button=sender;
    button.enabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled=YES;
        
    });
    
 
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_clickZan];

    
    NSDictionary*params=@{@"user_id":[UserSession instance].user_id,@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"video_id":self.mainModel.video_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //成功了
            [JRToast showWithText:data[@"data"]];
            NSInteger number=[_mainModel.VideoZanNumber integerValue]+1;
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
