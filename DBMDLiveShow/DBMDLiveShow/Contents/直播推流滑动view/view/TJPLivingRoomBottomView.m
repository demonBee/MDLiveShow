//
//  TJPLivingRoomBottomView.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/14.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPLivingRoomBottomView.h"


@interface TJPLivingRoomBottomView()



@end

@implementation TJPLivingRoomBottomView

+ (TJPLivingRoomBottomView *)bottomView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TJPLivingRoomBottomView" owner:nil options:nil] lastObject];
}

//按枚举来 显示内容
-(void)setLiveType:(LiveRoomType)liveType{
    _liveType=liveType;
    
    if (liveType==LiveRoomTypeWatch) {
        self.setButton.hidden=YES;
    }else{
        self.setButton.hidden=NO;
    }
    
    
}


- (IBAction)chatBtnClick:(UIButton *)sender {
    self.buttonClickedBlock(LivingRoomBottomViewButtonClickTypeChat, sender);
}

- (IBAction)SetBtnClick:(id)sender {
    if (self.liveType==LiveRoomTypeWatch) {
        
        return;
    }else{
        self.buttonClickedBlock(LivingRoomBottomViewButtonClickTypeSet, sender);

    }
    
    
}

- (IBAction)messageBtnClick:(UIButton *)sender {
    self.buttonClickedBlock(LivingRoomBottomViewButtonClickTypeGift, sender);

}

- (IBAction)giftBtnClick:(UIButton *)sender {
    self.buttonClickedBlock(LivingRoomBottomViewButtonClickTypeWork, sender);

}
- (IBAction)shareBtnClick:(UIButton *)sender {
    self.buttonClickedBlock(LivingRoomBottomViewButtonClickTypeShare, sender);

}
- (IBAction)backBtnClick:(UIButton *)sender {
    self.buttonClickedBlock(LivingRoomBottomViewButtonClickTypeBack, sender);

}


@end
