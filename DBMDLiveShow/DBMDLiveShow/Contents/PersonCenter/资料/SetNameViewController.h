//
//  SetNameViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TypeNameOrNumber){
    TypeNameOrNumberName=0,
    TypeNameOrNumberNumber
    
};

@interface SetNameViewController : UIViewController
//
@property(nonatomic,strong)NSString*textFieldString;   //textField 的内容  由上个控制器传过来
@property(nonatomic,assign)TypeNameOrNumber typee;   //类型
@property(nonatomic,strong)void(^saveBlock)(NSString*str);

@property (weak, nonatomic) IBOutlet UIView *textFieldView;  //textField上的view
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end
