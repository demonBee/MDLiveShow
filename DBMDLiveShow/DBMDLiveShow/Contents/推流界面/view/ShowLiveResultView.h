//
//  ShowLiveResultView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"
#import "endShowModel.h"

@interface ShowLiveResultView : UIView
@property(nonatomic,strong)NewPersonInfoModel*mainModel;
+(instancetype)creatResultViewWith:(NewPersonInfoModel*)model;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *liveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *livePersonNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addAttentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addMBLabel;




@property(nonatomic,strong)endShowModel*endModel;  //结束直播时候显示的model

@end
