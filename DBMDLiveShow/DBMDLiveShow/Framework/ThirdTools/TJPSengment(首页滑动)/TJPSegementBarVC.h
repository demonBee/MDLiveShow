//
//  TJPSegementBarVC.h
//  TJPSengment
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 tangjiapeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJPSegmentBar.h"


@interface TJPSegementBarVC : UIViewController

@property (nonatomic, weak) TJPSegmentBar *segementBar;


- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;


@end
