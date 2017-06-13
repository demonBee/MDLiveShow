//
//  LiveRoomPointCollectionReusableView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/7.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "LiveRoomPointCollectionReusableView.h"

@interface LiveRoomPointCollectionReusableView()
@property(nonatomic,strong)UILabel*mainLabel;
@end

@implementation LiveRoomPointCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.mainLabel=[[UILabel alloc]initWithFrame:frame];
        self.mainLabel.numberOfLines=0;
        self.mainLabel.font=[UIFont systemFontOfSize:14];
        self.mainLabel.textColor=[UIColor greenColor];
        [self addSubview:self.mainLabel];
        
        
        
        
    }
    
    return self;
}

-(void)setTextStr:(NSString *)textStr{
    _textStr=textStr;
    self.mainLabel.text=textStr;
    
    
}

+(CGFloat)getcollectionViewSizeWithText:(NSString*)text andMaxWith:(CGFloat)maxWith{
  CGFloat cellHeight=  [text boundingRectWithSize:CGSizeMake(maxWith, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    
    return cellHeight;
}



//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.mainLabel.frame=self.frame;
//    
//    
//}

@end
