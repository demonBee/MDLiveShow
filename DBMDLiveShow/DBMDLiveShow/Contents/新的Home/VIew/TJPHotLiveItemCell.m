//
//  TJPHotLiveItemCell.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/9.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPHotLiveItemCell.h"
#import "NewPersonInfoModel.h"


//#import "UIImageView+XMGExtension.h"


@interface TJPHotLiveItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *anchorImageView;
@property (weak, nonatomic) IBOutlet UIButton *defineButton;


@end

@implementation TJPHotLiveItemCell


-(void)setLiveItem:(NewPersonInfoModel *)liveItem
{
    _liveItem = liveItem;
    
    NSURL *imageUrl;
    if ([liveItem.portrait hasPrefix:@"https://"]) {
        imageUrl = [NSURL URLWithString:liveItem.portrait];
    }else {
         imageUrl = [NSURL URLWithString:liveItem.portrait];
    }
    [self.headImageView setURLImageWithURL:imageUrl placeHoldImage:[UIImage imageNamed:@"placeholderPhoto"] isCircle:YES];
    
    //城市
    self.cityLabel.text=liveItem.city;
    
     if (!liveItem.room_name.length) {
        _addressLabel.text = @"没有标题?";
    }else{
        _addressLabel.text = [NSString stringWithFormat:@"%@", liveItem.room_name];
    }
    
    self.nameLabel.text = liveItem.nick;
    
    [self.anchorImageView setURLImageWithURL:imageUrl placeHoldImage:[UIImage imageNamed:@"placeholderPhoto"] isCircle:NO];

    

    //主播的等级
    if (!liveItem.LiveLevel) {
        [self.defineButton setTitle:@"000" forState:UIControlStateNormal];
    }else{
        [self.defineButton setTitle:liveItem.LiveLevel forState:UIControlStateNormal];
        
    }

    
    self.lookCountLabel.text =liveItem.online_users;
//    self.lookCountLabel.text = [self dealWithOnlineNumber:[liveItem.online_users integerValue]];
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




- (void)awakeFromNib {
    [super awakeFromNib];
    
    

}



@end
