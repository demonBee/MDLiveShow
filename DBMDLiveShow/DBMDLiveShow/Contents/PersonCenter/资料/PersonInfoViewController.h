//
//  PersonInfoViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/18.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBaseViewController.h"
#import "NewPersonInfoModel.h"

@interface PersonInfoViewController : DBBaseViewController

-(instancetype)initWithDatas:(NewPersonInfoModel*)model;

@end
