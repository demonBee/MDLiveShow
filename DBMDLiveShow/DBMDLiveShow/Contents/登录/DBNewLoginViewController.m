//
//  DBNewLoginViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBNewLoginViewController.h"
#import "XLTabBarViewController.h"
#import "DBAdvermentViewController.h"

@interface DBNewLoginViewController ()

@property (nonatomic, assign) UMSocialPlatformType platform;

@end

@implementation DBNewLoginViewController

static DBNewLoginViewController*loginManager=nil;
+(DBNewLoginViewController*)managerLogin{
    if (!loginManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            loginManager=[[DBNewLoginViewController alloc]init];
        });
    }
    return loginManager;
}

//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self ToAutoLogin];
//        
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self setUI];
    
    //自动登录
    [self ToAutoLogin];
    
    NSString*aa=DBGetStringWithKeyFromTable(@"L登录即视为同意", nil);
    NSString*bb=DBGetStringWithKeyFromTable(@"L注册协议", nil);
    
    
    
    
//    NSString*buttonTitle=self.agreementButton.title;
//    NSString*frontTitle=[buttonTitle substringToIndex:buttonTitle.length-4];
//    NSString*fourTitle=[buttonTitle substringFromIndex:buttonTitle.length-4];
    NSMutableAttributedString*frontText=[[NSMutableAttributedString alloc]initWithString:aa attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    NSMutableAttributedString*lastFour=[[NSMutableAttributedString alloc]initWithString:bb attributes:@{NSForegroundColorAttributeName:KNaviColor}];
    
    [frontText appendAttributedString:lastFour];
    [self.agreementButton setAttributedTitle:frontText forState:UIControlStateNormal];
    
 
    
    
    
}




-(void)setUI{
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        self.wechatButton.hidden=YES;
    }
    
//    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]){
//        self.qqButton.hidden=YES;
//    }
    
//    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]){
//        self.weiboButton.hidden=YES;
//    }
    
    //纯是 为了测试
#if TARGET_IPHONE_SIMULATOR
    
    self.weiboButton.hidden=NO;
#elif TARGET_OS_IPHONE
    
#endif
    
    
    self.title=DBGetStringWithKeyFromTable(@"L登录", nil);
    
    [self.getCodeButton setTitle:DBGetStringWithKeyFromTable(@"L获取验证码", nil)];
    self.getCodeButton.titleLabel.font=[UIFont systemFontOfSize:14];

    self.getCodeButton.layer.borderWidth=1;
    self.getCodeButton.layer.borderColor=DBColor(204, 204, 204).CGColor;
    self.getCodeButton.layer.cornerRadius=3;
    
    
    self.loginButton.backgroundColor=KNaviColor;
    self.loginButton.layer.cornerRadius=10;
    self.loginButton.layer.masksToBounds=YES;
    
    self.wechatButton.layer.cornerRadius=20;
    self.qqButton.layer.cornerRadius=20;
    self.weiboButton.layer.cornerRadius=20;
    
    self.codeTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    
}






#pragma mark  touch

- (IBAction)clickAdvermentButton:(id)sender {
    DBAdvermentViewController*vc=[[DBAdvermentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



//获取验证码
- (IBAction)clickGetCode:(STCountDownButton*)sender {
    if (self.phoneTextField.text.length!=11) {
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L请正确输入手机号码", nil)];
        return;
    }

    sender.second=30;
    [sender start];

    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RegisterCode];
    NSDictionary*params=@{@"phone":self.phoneTextField.text};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"msg"]];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
}

//得到手机的openID
- (IBAction)clickPhoneLogin:(id)sender {
//    phoneNumber
//    [KUSERDEFAULT setObject:@"phoneNumber" forKey:AutoLoginType];

    
    //先吊接口得到 手机的openID 并保存到本地
    //在用这个openID 吊用总的登录接口
    if (self.phoneTextField.text.length==11&&self.codeTextField.text.length>=2) {
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_getPhoneOpenID];
        NSDictionary*params=@{@"phone":self.phoneTextField.text,@"code":self.codeTextField.text};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"errorCode"] integerValue]==0&&data!=nil) {
                NSString*open_id=data[@"data"];
                NSString*platForm=@"phoneNumber";
                [KUSERDEFAULT setObject:@"phoneNumber" forKey:AutoLoginType];
                [KUSERDEFAULT setObject:open_id forKey:PhoneOpenID];
//                if (!open_id) {
//                    [JRToast showWithText:@"openid为空"];
//                    return ;
//                }
                
                [self LoginWithPlatForm:platForm andOpenID:open_id andThirdResult:nil];
                
                
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
            
       
            
        }];
        
        
        
        
    }else{
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L手机号或验证码有误", nil)];
    }

}




- (IBAction)wechatLogin:(id)sender {
    [KUSERDEFAULT setObject:@"UMSocialPlatformType_WechatSession" forKey:AutoLoginType];
   
    NSString*platForm=@"UMSocialPlatformType_WechatSession";
    [[DBBaseViewController sharedManager]getUMShareDatasWithPlatformType:platForm success:^(UMSocialUserInfoResponse *resp) {
         //这里的uid 才是open_id
        NSString*open_id=resp.uid;
        
        if (!open_id) {
            [JRToast showWithText:@"openid为空"];
            return ;
        }
        

        
        [self LoginWithPlatForm:platForm andOpenID:open_id andThirdResult:resp];
        
        
        
        
    } failure:^(NSError *error) {
         [KUSERDEFAULT removeObjectForKey:AutoLoginType];
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L获取友盟的open_id失败", nil)];
    }];

    
}
- (IBAction)qqLogin:(id)sender {
    [KUSERDEFAULT setObject:@"UMSocialPlatformType_QQ" forKey:AutoLoginType];
  
    NSString*platForm=@"UMSocialPlatformType_QQ";
    [[DBBaseViewController sharedManager]getUMShareDatasWithPlatformType:platForm success:^(UMSocialUserInfoResponse *resp) {
        //这里的uid 才是open_id
        NSString*open_id=resp.uid;
        
        if (!open_id) {
            [JRToast showWithText:@"openid为空"];
            return ;
        }
        

        
        [self LoginWithPlatForm:platForm andOpenID:open_id andThirdResult:resp];
        
        
        
        
    } failure:^(NSError *error) {
        [KUSERDEFAULT removeObjectForKey:AutoLoginType];
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L获取友盟的open_id失败", nil)];
    }];


    
}
- (IBAction)weboLogin:(id)sender {
    [KUSERDEFAULT setObject:@"UMSocialPlatformType_Sina" forKey:AutoLoginType];
   
    NSString*platForm=@"UMSocialPlatformType_Sina";
    [[DBBaseViewController sharedManager]getUMShareDatasWithPlatformType:platForm success:^(UMSocialUserInfoResponse *resp) {
         //这里的uid 才是open_id
        NSString*open_id=resp.uid;
        
        if (!open_id) {
            [JRToast showWithText:@"openid为空"];
            return ;
        }
        

        
        
        [self LoginWithPlatForm:platForm andOpenID:open_id andThirdResult:resp];
        
        
        
        
    } failure:^(NSError *error) {
         [KUSERDEFAULT removeObjectForKey:AutoLoginType];
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L获取友盟的open_id失败", nil)];
    }];


    
    
}



#pragma mark  -- 登录
//登录的openID 和 platForm
-(void)LoginWithPlatForm:(NSString*)platForm andOpenID:(NSString*)open_id andThirdResult:(UMSocialUserInfoResponse *)resp{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_login];
    NSDictionary*dic=@{@"openid":open_id,@"platformType":platForm};
    NSMutableDictionary*params=[[NSMutableDictionary alloc]initWithDictionary:dic];
    if (![platForm isEqualToString:@"phoneNumber"]) {
        [params setObject:resp.gender forKey:@"gender"];
        [params setObject:resp.name forKey:@"name"];
        [params setObject:resp.iconurl forKey:@"iconurl"];
        
    }
    
    
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0&&data!=nil) {
            [UserSession saveUserInfoWithDic:data[@"data"]];
            
            
            XLTabBarViewController* vc=[[XLTabBarViewController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController=vc;
            
            
            
            
            
        }else{
              [UserSession cleanUser];
            
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
    
    
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


#pragma mark  隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}



#pragma mark 自动登录  给 appDelegate
-(void)ToAutoLogin{
    NSString*platformType=[KUSERDEFAULT objectForKey:AutoLoginType];
    NSString*openid_phone=[KUSERDEFAULT objectForKey:PhoneOpenID];
    
    if (!platformType) {
        
              return;
        
    }else{
        if ([platformType isEqualToString:@"phoneNumber"]) {
            [self LoginWithPlatForm:platformType andOpenID:openid_phone andThirdResult:nil];
            
        }else if ([platformType isEqualToString:@"UMSocialPlatformType_WechatSession"]){
            [self wechatLogin:nil];
            
        }else if ([platformType isEqualToString:@"UMSocialPlatformType_QQ"]){
            [self qqLogin:nil];
            
        }else if ([platformType isEqualToString:@"UMSocialPlatformType_Sina"]){
            [self weboLogin:nil];
        }else{
            return;
        }
        
        
        
        
    }
    
    
}



@end
