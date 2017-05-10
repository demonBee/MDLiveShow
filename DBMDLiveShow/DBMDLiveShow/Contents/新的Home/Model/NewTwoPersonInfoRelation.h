//
//  NewTwoPersonInfoRelation.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/15.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewPersonInfoModel.h"

//主要接口的 relation 下的数据
@interface NewTwoPersonInfoRelation : NSObject
@property(nonatomic,strong)NSString*isFollow;   //我是否关注了 这个直播间


@end
