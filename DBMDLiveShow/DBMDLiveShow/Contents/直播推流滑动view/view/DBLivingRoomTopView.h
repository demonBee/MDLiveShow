//
//  DBLivingRoomTopView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"

@interface DBLivingRoomTopView : UIView

/** model*/
@property (nonatomic, strong) NewPersonInfoModel *mainModel;

//这个是需要移除的时间
@property (nonatomic, weak) NSTimer *timer;

@end
