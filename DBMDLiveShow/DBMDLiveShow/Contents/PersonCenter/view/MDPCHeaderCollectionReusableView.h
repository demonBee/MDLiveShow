//
//  MDPCHeaderCollectionReusableView.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/16.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"

@interface MDPCHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maleImage;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *consumerButton;   //消费等级
@property (weak, nonatomic) IBOutlet UIButton *anchor;           //主播等级

@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *livetimeLabel;



@property (weak, nonatomic) IBOutlet UIView *mainView0;
@property (weak, nonatomic) IBOutlet UIView *mainView1;
@property (weak, nonatomic) IBOutlet UIView *mainView2;



@property(nonatomic,strong)NewPersonInfoModel*model;
@property(nonatomic,copy)void(^followBlock)();
@property(nonatomic,copy)void(^fansBlock)();


@end
