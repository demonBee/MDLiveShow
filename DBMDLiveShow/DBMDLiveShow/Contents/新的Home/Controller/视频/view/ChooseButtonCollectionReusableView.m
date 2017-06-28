//
//  ChooseButtonCollectionReusableView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ChooseButtonCollectionReusableView.h"
#import "YJSegmentedControl.h"

@interface ChooseButtonCollectionReusableView()<YJSegmentedControlDelegate>

@end

@implementation ChooseButtonCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setButtonDatas:(NSArray *)buttonDatas{
    _buttonDatas=buttonDatas;
    
    NSArray*titleDatas=_buttonDatas;
    YJSegmentedControl*topView=[YJSegmentedControl segmentedControlFrame:self.frame titleDataSource:titleDatas backgroundColor:KNaviColor titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:14] selectColor:[UIColor blackColor] buttonDownColor:[UIColor whiteColor] Delegate:self];
    self.topView=topView;
    [self addSubview:topView];

    
    
}

#pragma mark  --  delegate
-(void)segumentSelectionChange:(NSInteger)selection{
//    MyLog(@"%lu",selection);
    if (self.clickButtonBlock) {
        self.clickButtonBlock(selection);
    }
    
    
}



@end
