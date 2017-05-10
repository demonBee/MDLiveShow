//
//  UserSession.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/6.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import "NewPersonInfoModel.h"


@interface UserSession : NSObject
@property (nonatomic,assign)BOOL isLogin;   //是否登录
@property (nonatomic,copy)NSString * token;  //uid   token
@property (nonatomic,copy)NSString * user_id;  //账户
@property(nonatomic,strong)NewPersonInfoModel*user_info;





//登录 之后赋值
+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic;
+ (UserSession *) instance;   //单例
+ (void)cleanUser;     //清空






@end
