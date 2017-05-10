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
    
}



-(void)setMainModel:(VideoModel *)mainModel{
    _mainModel=mainModel;
    
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

@end
