//
//  DBBaseViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBBaseViewController.h"

@interface DBBaseViewController ()<UMSocialShareMenuViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation DBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //分享
    [self setUpShare];
    
    
}

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static DBBaseViewController*vc;
    dispatch_once(&onceToken, ^{
        vc=[[DBBaseViewController alloc]init];
    });
    return vc;
}


#pragma mark  --  分享功能


-(void)showShareMenuWithAnchor_id:(NSString*)idd{
    MyLog(@"分享");
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //点击了某个分享按钮之后 成功就吊用 获取分享信息的接口
        //获取了分享的信息 在
        [self shareWebPageToPlatformType:platformType andAnchor_id:idd];
       
        

    }];
    
    
}


//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andAnchor_id:(NSString*)idd
{
    //这里是吊用获取分享内容的接口
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ShareInfo];
    NSDictionary*params=@{@"anchor_id":idd};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //    NSString*imageStr=@"https://a-ssl.duitang.com/uploads/item/201606/28/20160628132132_JEnik.jpeg";
            //    NSString*titleStr=@"压缩";
            //    NSString*desStr=@"哈撒ki，面对疾风吧";
            //    NSString*webStr=@"www.baidu.com";
            
            NSString*imageStr=data[@"data"][@"head_img"];
            NSString*titleStr=data[@"data"][@"nickname"];
            NSString*desStr;
            if (data[@"data"][@"room_name"]==nil) {
                desStr=DBGetStringWithKeyFromTable(@"L无房间名", nil);
            }else{
                desStr=data[@"data"][@"room_name"];
            }
            NSString*webStr=data[@"data"][@"share_url"];
            
            
            //分享网页的数据
            [self SharefunctionPlatform:platformType andImage:imageStr andtitle:titleStr anddes:desStr andweb:webStr];

        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
        
    }];
}


     
-(void)SharefunctionPlatform:(UMSocialPlatformType)platformType andImage:(NSString*)imageStr andtitle:(NSString*)titleStr anddes:(NSString*)desStr andweb:(NSString*)webStr{
    //分享
    [self setUpShare];

    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //imageStr
//#warning 1 这个要注释掉
//    imageStr=@"http://api.zhiboquan.net/Public/Upload/20170410/14917909792094.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:desStr thumImage:imageStr];
    //设置网页地址
    shareObject.webpageUrl = webStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //我估计是图片没有的问题造成的
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            [JRToast showWithText:[NSString stringWithFormat:@"%@",error]];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
                
                [self getSharePoint];
                
                
            }else{
                
                [JRToast showWithText:[NSString stringWithFormat:@"%@",data]];
            }
        }
        
    }];
    
  
    
}

-(void)setUpShare{
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];

    //设置用户自定义的平台
    NSMutableArray*mtArray=[NSMutableArray array];
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [mtArray addObject:@(UMSocialPlatformType_WechatSession)];
        [mtArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
        [mtArray addObject:@(UMSocialPlatformType_WechatFavorite)];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]){
        [mtArray addObject:@(UMSocialPlatformType_QQ)];
        [mtArray addObject:@(UMSocialPlatformType_Qzone)];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]){
        [mtArray addObject:@(UMSocialPlatformType_Sina)];
        
    }
    
    [UMSocialUIManager setPreDefinePlatforms:mtArray];
    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
//                                               @(UMSocialPlatformType_WechatTimeLine),
//                                               @(UMSocialPlatformType_WechatFavorite),
//                                               @(UMSocialPlatformType_QQ),
//                                               @(UMSocialPlatformType_Qzone),
//                                               @(UMSocialPlatformType_Sina),
//                                               
//                                               ]];
    //    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    
    
}

//友盟退出登录
-(void)UMCancelLogin:(NSString*)typeStr{
    UMSocialPlatformType platType=0;
    if ([typeStr isEqualToString:@"UMSocialPlatformType_WechatSession"]) {
        platType=UMSocialPlatformType_WechatSession;
    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_Sina"]){
        platType=UMSocialPlatformType_Sina;
    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_QQ"]){
        platType=UMSocialPlatformType_QQ;
    }else{
         platType=UMSocialPlatformType_WechatSession;
    }
    
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platType completion:^(id result, NSError *error) {
      
        
        
    }];

    
}


//分享结束 回调得到马币  这里要有个接口
-(void)getSharePoint{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SignTo];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"type":@"2"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"msg"]];
            [UserSession instance].user_info.CurrencyNumber=data[@"data"];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
    
    
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}




//得到友盟分享的所有数据
-(void)getUMShareDatasWithPlatformType:(NSString*)typeStr success:(void(^)(UMSocialUserInfoResponse* resp))success failure:(void(^)(NSError*error))fail{
    UMSocialPlatformType platType=0;
    if ([typeStr isEqualToString:@"UMSocialPlatformType_WechatSession"]) {
        platType=UMSocialPlatformType_WechatSession;
    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_Sina"]){
        platType=UMSocialPlatformType_Sina;
    }else if ([typeStr isEqualToString:@"UMSocialPlatformType_QQ"]){
        platType=UMSocialPlatformType_QQ;
    }else{
        fail(nil);
    }

    
    //得到 所有授权的东西
//    if (![[UMSocialManager defaultManager] isInstall:platType]) {
//        fail(nil);
//    }else{
    
    
    [[UMSocialManager defaultManager]getUserInfoWithPlatform:platType currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [JRToast showWithText:[NSString stringWithFormat:@"%@",error]];
            fail(nil);
            
        }else{
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                
                UMSocialUserInfoResponse *resp = result;
                
//                NSString*uid=resp.uid;
//                NSString*platform=typeStr;
//                
//                NSString*name=resp.name;
//                NSString*iconurl=resp.iconurl;
//                NSString*gender=resp.gender;

                
                success(resp);
            
            }else{
                fail(nil);
            }
        }

        
        
    }];
    
    
    

//    }
  
}




#pragma mark  --  支付宝支付
//-(void)ToaliPay:(NSString*)orderStringg{
//    //吊用接口  传 多少钱  得到 orderString    RSA(SHA1)密钥 老版的 没有用罪行的
//    NSString *orderString =orderStringg;
//    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//    NSString *appScheme = @"MDShowAliSDK";
//    
//    // NOTE: 调用支付结果开始支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
//        
//    }];
//    
//    
//}
//
//
//
//#pragma mark  -- 微信支付
//-(void)TowechatPay:(NSDictionary*)dict{
//    //    NSString *res = [WXApiRequestHandler jumpToBizPay];
//    //    if( ![@"" isEqual:res] ){
//    //        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    //
//    //        [alter show];
//    //        [alter release];
//    //    }
//    
//    //接口 得到所有需要的东西
//    
//    
//    //    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//    //
//    //    //调起微信支付
//    //    PayReq* req             = [[[PayReq alloc] init]autorelease];
//    //    req.partnerId           = [dict objectForKey:@"partnerid"];
//    //    req.prepayId            = [dict objectForKey:@"prepayid"];
//    //    req.nonceStr            = [dict objectForKey:@"noncestr"];
//    //    req.timeStamp           = stamp.intValue;
//    //    req.package             = [dict objectForKey:@"package"];
//    //    req.sign                = [dict objectForKey:@"sign"];
//    //    [WXApi sendReq:req];
//    
//    
//    PayReq* req  = [[PayReq alloc] init];
//    req.partnerId           = dict[@"partnerid"];
//    req.prepayId            = dict[@"prepayid"];
//    req.nonceStr            = dict[@"nonce_str"];
//    req.timeStamp           = [dict[@"timestamp"] intValue];
//    req.package             = dict[@"package"];
//    req.sign                = dict[@"sign"];
//    
//    [WXApi sendReq:req];
//    
//};



#pragma mark - WXApiDelegate
//- (void)onResp:(BaseResp *)resp {
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
//    
//}






#pragma mark  -- 使用相册
//点击相册的使用方法
-(void)TouchAddImage{
    
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L从相册中选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing=YES;
        imagePicker.delegate=self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing=YES;
        imagePicker.delegate=self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}




//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
//    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    
//    //吊接口  照片
//    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UIImageView*imageView=[cell viewWithTag:111];
//    imageView.image=newPhoto;
    
    
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
