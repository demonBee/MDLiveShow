//
//  FollowFansViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FollowFansVC){
    FollowFansVCFollow=0,
    FollowFansVCFans
    
};

@interface FollowFansViewController : UIViewController


+(instancetype)creatVCWith:(FollowFansVC)vc;


@end
