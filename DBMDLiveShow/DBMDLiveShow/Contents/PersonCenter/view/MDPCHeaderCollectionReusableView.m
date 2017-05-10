//
//  MDPCHeaderCollectionReusableView.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/16.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDPCHeaderCollectionReusableView.h"

@implementation MDPCHeaderCollectionReusableView


-(void)setModel:(NewPersonInfoModel *)model{
    _model=model;
    
    self.followLabel.text=DBGetStringWithKeyFromTable(@"L关注", nil);
    self.fansLabel.text=DBGetStringWithKeyFromTable(@"L粉丝", nil);
    self.livetimeLabel.text=DBGetStringWithKeyFromTable(@"L直播时长(h)", nil);
    
    //背景色
    UIView*BGView=[self viewWithTag:911];
    BGView.backgroundColor=KNaviColor;
    
    
    //头像
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    //名字
    self.nameLabel.text=model.nick;
    //性别
   NSString*sex=model.gender;
    if ([sex isEqualToString:@"m"]) {
        self.maleImage.image=[UIImage imageNamed:@"icon_pc_male"];
    }else{
        self.maleImage.image=[UIImage imageNamed:@"icon_pc_female"];
        
    }
    //消费者等级
    [self.consumerButton setTitle:model.watcherLevel forState:UIControlStateNormal];
    //主播等级
    [self.anchor setTitle:model.LiveLevel forState:UIControlStateNormal];
    //直播间号码
    self.numberLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L直播间号：%@", nil),model.roomid];
    //个性签名
    self.titleLabel.text=model.signature;
    
    
    //关注的数量
    UILabel*followNum=[self.mainView0 viewWithTag:11];
    followNum.text=model.attentionNumber;
    //粉丝的数量
    UILabel*fansNum=[self.mainView1 viewWithTag:11];
    fansNum.text=model.fansNumber;
    //直播的时长
    UILabel*showTimer=[self.mainView2 viewWithTag:11];
    showTimer.text=model.liveTimer;

    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerView.layer.cornerRadius=75/2;
    self.headerView.layer.masksToBounds=YES;
    
    
    
    UITapGestureRecognizer*tap0=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap0)];
    [self.mainView0 addGestureRecognizer:tap0];
    
    UITapGestureRecognizer*tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap1)];
    [self.mainView1 addGestureRecognizer:tap1];
    
    
    
    
    
}

-(void)touchTap0{
  
    if (self.followBlock) {
        self.followBlock();
    }
    
}


-(void)touchTap1{
    if (self.fansBlock) {
        self.fansBlock();
    }
    
}


@end
