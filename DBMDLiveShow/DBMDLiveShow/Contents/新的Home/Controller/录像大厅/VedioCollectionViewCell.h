//
//  VedioCollectionViewCell.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VedioCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *anchor_photo;
@property (weak, nonatomic) IBOutlet UILabel *anchor_nick;

@property (weak, nonatomic) IBOutlet UIView *CoverView;
@property (weak, nonatomic) IBOutlet UILabel *timeLongLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomName;



@property(nonatomic,strong)VideoModel*mainModel;
@end
