//
//  DBNewLoginViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBaseViewController.h"
#import "STCountDownButton.h"

@interface DBNewLoginViewController : UIViewController
//+(DBNewLoginViewController*)managerLogin;   //单利
////自动登录
//-(void)ToAutoLogin;
//@property(nonatomic,strong)void(^LoginSuccessBlock)();
//@property(nonatomic,strong)void(^loginFailBlock)();


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet STCountDownButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;

@property (weak, nonatomic) IBOutlet UIButton *agreementButton;

@end
