//
//  PrePaidTableViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "PrePaidTableViewCell.h"

@implementation PrePaidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.moneyButton.layer.borderWidth=1;
    self.moneyButton.layer.borderColor=KNaviColor.CGColor;
    self.moneyButton.userInteractionEnabled=NO;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}





@end
