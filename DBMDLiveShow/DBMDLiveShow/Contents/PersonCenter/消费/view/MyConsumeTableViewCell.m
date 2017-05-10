//
//  MyConsumeTableViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MyConsumeTableViewCell.h"

@implementation MyConsumeTableViewCell

-(void)setModel:(PresentRecordModel *)model{
    _model=model;
    
    self.monthLabel.text=model.monthDay;
    self.timeLabel.text=model.hourMin;
    
    [self.giftimage sd_setImageWithURL:[NSURL URLWithString:model.PayForAnchorPhoto] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.giftName.text=[NSString stringWithFormat:@"%@X1",model.giftName];
    self.reasonLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L赠送给：%@", nil),model.PayForAnchorNick];
    self.spendMoney.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L-%@珍珠", nil),model.giftMB];
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
