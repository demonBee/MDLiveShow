//
//  OtherShowTableViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "OtherShowTableViewCell.h"

@implementation OtherShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImage.layer.cornerRadius=25;
    self.photoImage.layer.masksToBounds=YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
