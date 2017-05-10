//
//  DBNoDataView.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/18.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBNoDataView : UIView

+(instancetype)creatNoDataView;
@property(nonatomic,strong)void(^clickReloadBlock)();


@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;


@end
