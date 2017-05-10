//
//  SSCollectionViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/16.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "SSCollectionViewCell.h"
#import "NewPersonInfoModel.h"


@implementation SSCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   

    
    self.liveLabel.backgroundColor=[UIColor whiteColor];
    self.liveLabel.layer.cornerRadius=3;
    self.liveLabel.layer.masksToBounds=YES;
    
}


-(void)setLiveItem:(NewPersonInfoModel *)liveItem{
     _liveItem = liveItem;
    
    
    self.liveLabel.text=liveItem.city;
    
    NSURL *imageUrl;
    if ([liveItem.portrait hasPrefix:@"http://"]) {
        imageUrl = [NSURL URLWithString:liveItem.portrait];
    }else {
       imageUrl = [NSURL URLWithString:liveItem.portrait];
    }
    //最大的直播图
    [self.mainImageView setURLImageWithURL:imageUrl placeHoldImage:[UIImage imageNamed:@"placeholderPhoto"] isCircle:NO];

    //主播的名字
    self.nameLabel.text = liveItem.nick;
    
    //主播的标题
    if (!liveItem.room_name.length) {
        self.titleLabel.text = DBGetStringWithKeyFromTable(@"L没有标题?", nil);
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@", liveItem.room_name];
    }

    //主播的等级
    if (!liveItem.LiveLevel) {
        [self.defineButton setTitle:@"000" forState:UIControlStateNormal];
    }else{
        [self.defineButton setTitle:liveItem.LiveLevel forState:UIControlStateNormal];

    }
    
    //人数
    self.numberLabel.text= [self dealWithOnlineNumber:[liveItem.online_users integerValue]];
    
}

- (NSString *)dealWithOnlineNumber:(NSUInteger)number {

    
    
    NSString *resultStr;
    if (number >= 10000) {
        resultStr = [NSString stringWithFormat:@"%.1f万",
                     number / 10000.0];
    }else{
        resultStr = [NSString stringWithFormat:@"%zd", number];
    }
    return resultStr;
    
}


@end
