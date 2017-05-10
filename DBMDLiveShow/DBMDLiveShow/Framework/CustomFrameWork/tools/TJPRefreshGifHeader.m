//
//  TJPRefreshGifHeader.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/20.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPRefreshGifHeader.h"
@interface TJPRefreshGifHeader()

@property (nonatomic, strong) NSMutableArray *refreshingArr;
@property (nonatomic, strong) NSMutableArray *pullingArr;
@property (nonatomic, strong) NSMutableArray *idleArr;


@end

@implementation TJPRefreshGifHeader

- (NSMutableArray *)refreshingArr {
    if (!_refreshingArr) {
        _refreshingArr = [NSMutableArray array];
    }
    return _refreshingArr;
}

- (NSMutableArray *)pullingArr {
    if (!_pullingArr) {
        _pullingArr = [NSMutableArray array];
    }
    return _pullingArr;
}

- (NSMutableArray *)idleArr {
    if (!_idleArr) {
        _idleArr = [NSMutableArray array];
    }
    return _idleArr;
}

- (instancetype)init {

    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        for (int i = 1; i < 30; i++) {
            [self.refreshingArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_%i", i]]];
        }
        [self setImages:_refreshingArr  duration:1.5 forState:MJRefreshStateRefreshing];
        
        
        for (int i = 22; i < 29; i++) {
            [self.idleArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_%i", i]]];
        }
        [self setImages:_idleArr forState:MJRefreshStateIdle];
        [self setImages:_idleArr forState:MJRefreshStatePulling];

        
    }
    return self;
}



@end
