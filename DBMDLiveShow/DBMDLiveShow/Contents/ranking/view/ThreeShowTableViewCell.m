//
//  ThreeShowTableViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "ThreeShowTableViewCell.h"

@implementation ThreeShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor=XLColor(230, 224, 224);
    
    self.photoImage.layer.cornerRadius=40;
    self.photoImage.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
