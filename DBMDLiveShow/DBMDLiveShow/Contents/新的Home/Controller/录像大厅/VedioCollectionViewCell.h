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

@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;   //删除button
@property(nonatomic,copy)void(^clickDeleteBlock)();


@property(nonatomic,strong)VideoModel*mainModel;
@end
