//
//  DBChooseHotelShowView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chooseCityModel.h"

@interface DBChooseHotelShowView : UIView

+(instancetype)chooseHotelShowView;
-(void)getValue:(NSMutableArray*)allDatas;
@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,copy)void(^clickCityBlock)(chooseCityModel*mainModel);


-(void)show;
-(void)hidden;
@end
