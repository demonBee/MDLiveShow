//
//  ThreeShowTableViewCell.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
