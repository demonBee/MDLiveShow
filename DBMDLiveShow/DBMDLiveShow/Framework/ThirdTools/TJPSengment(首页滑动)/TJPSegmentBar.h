//
//  TJPSegmentBar.h
//  TJPSengment
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 tangjiapeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJPSegementBarConfig.h"

@class TJPSegmentBar;
@protocol TJPSegmentBarDelegate <NSObject>

/** 代理方法,告诉外界,内部的数据*/
- (void)segmentBar:(TJPSegmentBar *)segmentBar didSelectedIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;


@end

@interface TJPSegmentBar : UIView


/**
 快速创建一个选项卡

 @param frame frame
 @return 选项卡控件
 */
+ (instancetype)segmentBarWithFrame:(CGRect)frame;
/** 代理 */
@property (nonatomic, weak) id<TJPSegmentBarDelegate> delegate;

/** 数据源 */
@property (nonatomic, strong) NSArray <NSString *>*items;

//选中的索引
@property (nonatomic, assign) NSInteger selectIndex;


- (void)updateWithConfig:(void(^)(TJPSegementBarConfig * config))configBlock;


@end
