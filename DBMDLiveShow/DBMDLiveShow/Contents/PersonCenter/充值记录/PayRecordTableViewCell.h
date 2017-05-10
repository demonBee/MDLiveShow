//
//  PayRecordTableViewCell.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayRecordModel.h"

@interface PayRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;


@property(nonatomic,strong)PayRecordModel*mainModel;
@end
