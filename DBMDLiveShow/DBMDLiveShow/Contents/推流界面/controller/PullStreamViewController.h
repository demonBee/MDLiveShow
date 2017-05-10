//
//  PullStreamViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/2/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLMediaStreamingKit.h"
@interface PullStreamViewController : UIViewController

@property (nonatomic, strong) PLMediaStreamingSession *session;   //总的推流的类
@end
