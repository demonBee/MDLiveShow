//
//  DBVideoViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,videoType){
    videoTypeRecommendVedio=0,
    videoTypeMyVedio,
    videoTypeHotel
};

@interface DBVideoViewController : UIViewController

@property(nonatomic,assign)videoType typee;

@end
