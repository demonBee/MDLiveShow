//
//  LiveRoomPointCollectionReusableView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/7.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveRoomPointCollectionReusableView : UICollectionReusableView



@property(nonatomic,strong)NSString*textStr;
+(CGFloat)getcollectionViewSizeWithText:(NSString*)text andMaxWith:(CGFloat)maxWith;

@end
