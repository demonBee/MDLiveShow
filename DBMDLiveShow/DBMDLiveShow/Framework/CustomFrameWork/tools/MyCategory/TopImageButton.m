//
//  TopImageButton.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "TopImageButton.h"
@interface TopImageButton()


@end

@implementation TopImageButton

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self creat];
}


-(instancetype)initWithFrame:(CGRect)frame{
   self= [super initWithFrame:frame];
    if (self) {
        [self creat];
    }
    return self;
}


-(void)creat{
    CGFloat buttonWith=self.size.width;
    CGFloat buttonHeight=self.size.height;
    
    self.TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, buttonWith, buttonHeight/5*4)];
    self.TopImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:self.TopImageView];
    
    self.BottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.TopImageView.height, buttonWith, buttonHeight/5)];
    self.BottomLabel.textColor =[UIColor lightGrayColor];
    self.BottomLabel.textAlignment = NSTextAlignmentCenter;  //文字居中
    self.BottomLabel.adjustsFontSizeToFitWidth = YES;   //文字大小自适应
    [self addSubview:self.BottomLabel];

    
}

@end
