//
//  UserSession.m
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/6.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import "UserSession.h"
#import "DBNewLoginViewController.h"
#import "XLNavigationController.h"
#import "XLTabBarViewController.h"
#import "AppDelegate+DBDefault.h"
#import "DBBaseViewController.h"




@implementation UserSession

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

static UserSession *user = nil;
+ (UserSession *) instance{
    if (!user) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user=[[UserSession alloc]init];
        });
        user.token=@"";
        
        
        
    }
    
    return user;
}

+ (void)cleanUser{
     [UserSession instance];
    NSString*str=[KUSERDEFAULT objectForKey:AutoLoginType];
    [[DBBaseViewController sharedManager] UMCancelLogin:str];
    [KUSERDEFAULT removeObjectForKey:AutoLoginType];
    [KUSERDEFAULT removeObjectForKey:PhoneOpenID];
    user = nil;
    user=[[UserSession alloc]init];
    user.token=@"";
    
    DBNewLoginViewController* vc=[[DBNewLoginViewController alloc]initWithNibName:@"DBNewLoginViewController" bundle:nil];
    XLNavigationController*navi=[[XLNavigationController alloc]initWithRootViewController:vc];
    [UIApplication sharedApplication].keyWindow.rootViewController=navi;

 }




//登录 之后赋值
+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic{
    [UserSession instance];
    user=[UserSession yy_modelWithDictionary:dataDic];
    user.isLogin = YES;
    
    
}





@end
