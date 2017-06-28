//
//  MDVideoViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/19.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MDShortVideoType){
    MDShortVideoTypePageHome=0,
    MDShortVideoTypeMyVedio,
    MDShortVideoTypeHotel
};

@interface MDShortVideoViewController : UIViewController

@property(nonatomic,assign)MDShortVideoType typee;

@end
