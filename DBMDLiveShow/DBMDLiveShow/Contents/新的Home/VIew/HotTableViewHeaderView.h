//
//  HotTableViewHeaderView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotAdvertiseModel;

@interface HotTableViewHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)NSArray*allDatas;

@property(nonatomic,copy)void(^clickAdvertBlock)(HotAdvertiseModel*model);
@end
