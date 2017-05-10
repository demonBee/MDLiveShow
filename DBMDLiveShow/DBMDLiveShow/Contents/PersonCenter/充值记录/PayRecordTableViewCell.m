//
//  PayRecordTableViewCell.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "PayRecordTableViewCell.h"

@implementation PayRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMainModel:(PayRecordModel *)mainModel{
    _mainModel=mainModel;
    
    self.payTypeLabel.text=mainModel.pay_method;
    self.payMoneyLabel.text=[NSString stringWithFormat:@"+%@",mainModel.total_money];
    self.payTimeLabel.text=[DBTools TimeWholeFormat:mainModel.pay_time];
    self.orderNumberLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L订单号：%@", nil),mainModel.out_trade_no];
    
}


@end
