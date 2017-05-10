//
//  PrePaidViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreBuyViewController.h"


#import "NewPersonInfoModel.h"
#import "DBBaseViewController.h"


@interface PrePaidViewController : StoreBuyViewController

-(instancetype)initWithDatas:(NewPersonInfoModel*)datas;
@end
