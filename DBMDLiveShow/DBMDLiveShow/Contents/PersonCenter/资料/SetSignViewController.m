//
//  SetSignViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/20.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "SetSignViewController.h"

@interface SetSignViewController ()<UITextFieldDelegate>

@end

@implementation SetSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [super viewDidLoad];
    self.view.backgroundColor=DBColor(244, 244, 244);
    self.textFieldView.layer.borderColor=[UIColor blackColor].CGColor;
    self.textFieldView.layer.borderWidth=0.5;
    self.title=DBGetStringWithKeyFromTable(@"L个性签名", nil);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:DBGetStringWithKeyFromTable(@"L取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(leftItem)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:DBGetStringWithKeyFromTable(@"L保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightItem)];
    
//    if (!self.dataStr) {
//        self.dataStr=@"1314223412";
//    }
    self.textField.text=self.dataStr;
    self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textField.delegate=self;
//    [self.textField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}


#pragma mark  --delegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField becomeFirstResponder];
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    MyLog(@"22 %@",string);
//    
//    return YES;
//}

#pragma mark  -- touch
-(void)leftItem{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)rightItem{
    //点击保存
    if (self.saveBlock) {
        self.saveBlock(self.textField.text);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)textFieldDidChange:(NSNotification*)notification{
    UITextField*textField=notification.object;
 

    
    NSInteger aa =25;
    NSInteger showNum=aa-textField.text.length;
    if (showNum>=0) {
        self.showNumberLabel.text=[NSString stringWithFormat:@"%ld",showNum];
    }else{
        textField.text=[textField.text substringToIndex:25];
        
    }
    
    
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


#pragma mark  -- 隐藏键盘
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
