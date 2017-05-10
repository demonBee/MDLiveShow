//
//  DBFansTableViewCell.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"

@interface DBFansTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *FansLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;


//这个方法只有显示全部观众中用到
@property(nonatomic,strong)NewPersonInfoModel*modelItem;
@end
