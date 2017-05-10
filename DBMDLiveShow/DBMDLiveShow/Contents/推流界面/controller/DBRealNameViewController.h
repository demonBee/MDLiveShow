//
//  DBRealNameViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBaseViewController.h"


@interface DBRealNameViewController : DBBaseViewController

//已经提交了 实名认证  然后回来之后 吊接口 来刷新到已经提交了实名认证
@property(nonatomic,copy)void(^popUpdateBlock)();
@end
