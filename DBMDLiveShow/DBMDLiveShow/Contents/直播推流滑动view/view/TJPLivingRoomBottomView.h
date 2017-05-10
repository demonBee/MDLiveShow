//
//  TJPLivingRoomBottomView.h
//  TJPYingKe
//
//  Created by Walkman on 2016/12/14.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBLiveBGViewController.h"

typedef enum {
    
 
    LivingRoomBottomViewButtonClickTypeChat,
    
    LivingRoomBottomViewButtonClickTypeSet,  //功能
    
    LivingRoomBottomViewButtonClickTypeGift,
    LivingRoomBottomViewButtonClickTypeWork,
    LivingRoomBottomViewButtonClickTypeShare,
    LivingRoomBottomViewButtonClickTypeBack
    
}LivingRoomBottomViewButtonClickType;




@interface TJPLivingRoomBottomView : UIView

//加载xib
+ (TJPLivingRoomBottomView *)bottomView;
//给这个赋值 来判断要不要 隐藏功能按钮
@property(nonatomic,assign)LiveRoomType liveType;


@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIButton *workButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, copy) void(^buttonClickedBlock)(LivingRoomBottomViewButtonClickType clickType, UIButton *button);


@end
