//
//  DBUserPersonView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPersonInfoModel.h"

@interface DBUserPersonView : UIView
//创建
+ (instancetype)creatDBUserPersonView;
//赋值
@property(nonatomic,strong)NewPersonInfoModel*mainModel;

//关闭
@property (nonatomic, copy) void(^closeViewBlock)();

@end
