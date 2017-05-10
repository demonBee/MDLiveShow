//
//  DBFansTableViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "DBFansTableViewCell.h"

@implementation DBFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.photoImageView.layer.cornerRadius=35/2;
    self.photoImageView.layer.masksToBounds=YES;
    
    self.followButton.layer.cornerRadius=6;
    self.followButton.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setModelItem:(NewPersonInfoModel *)modelItem{
    _modelItem=modelItem;
    
    [self.photoImageView setURLImageWithURL:[NSURL URLWithString:modelItem.portrait] placeHoldImage:[UIImage imageNamed:@"placeholderPhoto"] isCircle:YES];
    
    self.NameLabel.text=modelItem.nick;
    
    self.FansLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L%@粉丝", nil),modelItem.fansNumber];
    
    self.followButton.hidden=YES;
}

@end
