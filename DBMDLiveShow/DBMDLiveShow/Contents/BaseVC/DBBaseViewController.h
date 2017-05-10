//
//  DBBaseViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UShareUI/UShareUI.h>
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"

// <WXApiDelegate>
@interface DBBaseViewController : UIViewController

#pragma 友盟很重要的一点     如果没有安装客户端直接把 友盟该第三方登录的按钮隐藏掉 友盟分享的按钮也隐藏掉
//设置友盟分享配置  使用友盟分享 集成自该控制器 然后要吊用此方法
-(void)setUpShare;
//友盟分享功能 分享的主播的id 
-(void)showShareMenuWithAnchor_id:(NSString*)idd;
//分享结束 回调得到马币
-(void)getSharePoint;
//友盟退出登录
-(void)UMCancelLogin:(NSString*)typeStr;
//得到友盟登录的所有数据
-(void)getUMShareDatasWithPlatformType:(NSString*)typeStr success:(void(^)(UMSocialUserInfoResponse* resp))success failure:(void(^)(NSError*error))fail;



////单利
+(instancetype)sharedManager;
////微信支付
//-(void)TowechatPay:(NSDictionary*)dict;
////支付宝支付
//-(void)ToaliPay:(NSString*)orderString;


//吊用照相机拍照
-(void)TouchAddImage;
//成功后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

@end
