//
//  MeipaiCollectionViewCell.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeiPaiHomeModel.h"

@interface MeipaiCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(nonatomic,copy)void(^clickDeleteBlock)();


@property(nonatomic,strong)MeiPaiHomeModel*mainModel;

@end
