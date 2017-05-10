//
//  SetSignViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSignViewController : UIViewController

@property(nonatomic,strong)NSString*dataStr;

@property (weak, nonatomic) IBOutlet UIView *textFieldView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *showNumberLabel;


@property(nonatomic,copy)void(^saveBlock)(NSString*str);
@end
