//
//  HotTableViewHeaderView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "HotTableViewHeaderView.h"
#import "SDCycleScrollView.h"
#import "HotAdvertiseModel.h"

@interface HotTableViewHeaderView()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView*cycleView;

@end
@implementation HotTableViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
       
        
        
    }
    return self;
}


-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    [_cycleView removeFromSuperview];
    _cycleView=nil;
    
    
    NSMutableArray*imageArray=[NSMutableArray array];
    for (HotAdvertiseModel*model in allDatas) {
        [imageArray addObject:model.img];
        
    }
    
    _cycleView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth,100) imagesGroup:imageArray andPlaceholder:@"placeholderPhoto"];
    _cycleView.autoScrollTimeInterval=5.0;
    _cycleView.delegate=self;
    [self addSubview:_cycleView];
    
   
    
    
}



#pragma mark   --- delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%lu",index);
    HotAdvertiseModel*model=self.allDatas[index];
    
    if (self.clickAdvertBlock) {
        self.clickAdvertBlock(model);
    }
    
}


@end
