//
//  PrePaidTableViewCell.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrePaidTableViewCell : UITableViewCell
//@property(nonatomic,strong)NSTimer*timer;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;


@end
