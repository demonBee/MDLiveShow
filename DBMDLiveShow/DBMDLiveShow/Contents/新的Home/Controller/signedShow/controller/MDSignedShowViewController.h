//
//  MDSignedShowViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/13.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,showType){
    showTypeAll=0,     //全部
    showTypeAttention,   //关注
    showTypeSign        //酒店签约
    
};

@interface MDSignedShowViewController : UIViewController
//这个界面 有3个地方  全部 我的关注  签约 这3个地方

@property(nonatomic,assign)showType showVC;
-(instancetype)initWithtype:(showType)type;

@end
