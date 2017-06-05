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
    
    self.anchor_photo.contentMode=UIViewContentModeScaleAspectFill;
    self.anchor_photo.clipsToBounds=YES;
    
    self.CoverView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    
    [self.zanButton setTitle:@"123"];
    self.zanButton.titleLabel.font=[UIFont systemFontOfSize:10];
    self.zanButton.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    [self.zanButton setImage:@"zanLove"];
    self.zanButton.imageEdgeInsets=UIEdgeInsetsMake(5,0, 5, 25);
    
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
    button.userInteractionEnabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled=YES;
        
    });
    
    MyLog(@"xxx");
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_clickZan];
#warning 1 删掉
    self.mainModel.video_id=@"3";
    
    NSDictionary*params=@{@"user_id":[UserSession instance].user_id,@"video_id":self.mainModel.video_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //成功了
            [JRToast showWithText:@"点赞成功"];
            [self.zanButton setTitle:data[@"data"]];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
    
    
    
}

@end
