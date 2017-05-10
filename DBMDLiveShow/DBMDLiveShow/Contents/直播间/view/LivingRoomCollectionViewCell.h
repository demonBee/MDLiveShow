//
//  LivingRoomCollectionViewCell.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/2/21.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"



@interface LivingRoomCollectionViewCell : UICollectionViewCell

/** model*/
@property (nonatomic, strong) NewPersonInfoModel *liveItem;

/** 父控制器*/
@property (nonatomic, weak) UIViewController *parentVc;



@end
