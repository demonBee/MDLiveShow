//
//  ChooseButtonCollectionReusableView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseButtonCollectionReusableView : UICollectionReusableView

@property(nonatomic,strong)NSArray*buttonDatas;

@property(nonatomic,copy)void(^clickButtonBlock)(NSInteger number);


@property(nonatomic,strong)YJSegmentedControl*topView;


@end
