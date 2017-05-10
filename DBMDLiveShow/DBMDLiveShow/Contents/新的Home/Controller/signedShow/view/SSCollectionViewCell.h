//
//  SSCollectionViewCell.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/16.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"
@interface SSCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;   // 城市
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *defineButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@property (nonatomic, strong) NewPersonInfoModel *liveItem;
@end
