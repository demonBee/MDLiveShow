//
//  DBNoDataView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/18.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBNoDataView.h"




@implementation DBNoDataView


+(instancetype)creatNoDataView{
    return [[[NSBundle mainBundle] loadNibNamed:@"DBNoDataView" owner:nil options:nil] lastObject];

    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.mainImageView.layer.cornerRadius=self.mainImageView.width/2;
    self.mainImageView.layer.masksToBounds=YES;
    self.mainImageView.image=[UIImage imageNamed:@"noData.jpg"];
    
    self.showLabel.text=DBGetStringWithKeyFromTable(@"L很遗憾！暂无数据", nil);
    [self.reloadButton setTitle:DBGetStringWithKeyFromTable(@"L重新加载", nil)];
    
}


#pragma mark  --touch

- (IBAction)clickReloadButton:(id)sender {
    if (self.clickReloadBlock) {
        self.hidden=YES;
        self.clickReloadBlock();
    }
    
}


@end
