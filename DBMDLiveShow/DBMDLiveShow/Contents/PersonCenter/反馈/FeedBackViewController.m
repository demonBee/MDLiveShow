//
//  FeedBackViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@property(nonatomic,assign)BOOL canSave;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputButton.backgroundColor=KNaviColor;
    self.title=DBGetStringWithKeyFromTable(@"L反馈", nil);
 
    self.showLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L还需输入%ld个字,才能提交", nil),[@"25" integerValue]];
    [self.inputButton setTitle:DBGetStringWithKeyFromTable(@"L可以提交", nil)];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=DBColor(244, 244, 244);
    
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextViewDidChange:) name:UITextViewTextDidChangeNotification object:self.myTextView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.myTextView becomeFirstResponder];
//    });
//    
    [self.inputButton addTarget:self action:@selector(touchPut)];
    
}


#pragma mark  --   touch
-(void)TextViewDidChange:(NSNotification*)notif{
    UITextView*textView=notif.object;
    
    NSInteger minNum=25;
    NSInteger num= minNum- textView.text.length;
    

    if (num>0) {
        _canSave=NO;
        self.showLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L还需输入%ld个字,才能提交", nil),num];
        
        
    }else{
        _canSave=YES;
        self.showLabel.text=DBGetStringWithKeyFromTable(@"L可以提交", nil);

    }
    
}



-(void)touchPut{
    if (!_canSave) {
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L您的反馈字数不足", nil)];
        return;
        
    }
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Feedback];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"customer_content":self.myTextView.text};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] integerValue]==0) {
            
            [JRToast showWithText:data[@"data"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
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

#pragma mark  -- 键盘收起
//隐藏键盘
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


@end
