//
//  DBRealNameViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/17.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBRealNameViewController.h"

@interface DBRealNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *identityTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property(nonatomic,strong)UIButton*imageSelectedButton;
@property(nonatomic,strong)NSMutableDictionary*saveTwoImageDic;
@property(nonatomic,strong)NSMutableArray*saveImageAddress;

@property(nonatomic,assign)BOOL canSave;
@end

@implementation DBRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L实名认证", nil);
    self.frontButton.layer.borderWidth=1;
    self.frontButton.layer.borderColor=KNaviColor.CGColor;
    self.frontButton.layer.cornerRadius=5;
    self.frontButton.layer.masksToBounds=YES;
    
    self.backButton.layer.borderWidth=1;
    self.backButton.layer.borderColor=KNaviColor.CGColor;
    self.backButton.layer.cornerRadius=5;
    self.backButton.layer.masksToBounds=YES;

    self.identityTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    
}

-(NSString*)judeCansave{
    _canSave=YES;
    if (self.nameTextField.text.length<2) {
        _canSave=NO;
        return DBGetStringWithKeyFromTable(@"L姓名输入有误", nil);
    }else if (self.identityTextField.text.length!=18){
        _canSave=NO;
        return DBGetStringWithKeyFromTable(@"L身份证输入有误", nil);
    }else if (self.phoneTextField.text.length!=11){
        _canSave=NO;
        return DBGetStringWithKeyFromTable(@"L手机号输入有误", nil);
    }else if (!self.frontButton.currentBackgroundImage){
        _canSave=NO;
        return DBGetStringWithKeyFromTable(@"L请上传正面图", nil);
    }else if (!self.backButton.currentBackgroundImage){
        _canSave=NO;
        return DBGetStringWithKeyFromTable(@"L请上传反面图", nil);
        
    }
    
    return nil;
    
}


#pragma mark -- touch
- (IBAction)clickFrontButton:(id)sender {
   
    self.imageSelectedButton=sender;
    
    [self TouchAddImage];
    
}



- (IBAction)clickBackButton:(id)sender {
    self.imageSelectedButton=sender;

    [self TouchAddImage];
}



- (IBAction)clickSendButton:(id)sender {
    NSString*errorStr=[self judeCansave];
    if (!_canSave) {
        [JRToast showWithText:errorStr];
        return;
    }
    
    //先上传两张图片
    [self updateImage];
}

#pragma mark  --datas
-(void)updateImage{
    UIImage*image1=self.saveTwoImageDic[@"frontButton"];
    UIImage*image2=self.saveTwoImageDic[@"backButton"];
    NSArray*TwoArray=@[image1,image2];
    [self.saveImageAddress removeAllObjects];
    
    for (UIImage*image in TwoArray) {
         NSData*data=UIImagePNGRepresentation(image);
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PostImage];
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"errorCode"] integerValue]==0) {
                NSString*photoUrlStr=data[@"data"];
                [self.saveImageAddress addObject:photoUrlStr];
                
                if (self.saveImageAddress.count==TwoArray.count) {
                    //图片地址都获取全了  就吊用接口  上传数据
                    [self updateAllInfo];
                }
                
              
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
            
            
        }];
 
        
    }
  
}


-(void)updateAllInfo{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RealName];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"nick":self.nameTextField.text,@"id_card_number":self.identityTextField.text,@"mobile":self.phoneTextField.text,@"id_card":self.saveImageAddress[0],@"id_card_back":self.saveImageAddress[1]};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"data"]];
            if (self.popUpdateBlock) {
                self.popUpdateBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.imageSelectedButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
    if ([self.imageSelectedButton isEqual:self.frontButton]) {
        [self.saveTwoImageDic setObject:newPhoto forKey:@"frontButton"];
        
    }else{
        [self.saveTwoImageDic setObject:newPhoto forKey:@"backButton"];
    }
    
    
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

#pragma mark  --set

-(NSMutableDictionary *)saveTwoImageDic{
    if (!_saveTwoImageDic) {
        _saveTwoImageDic=[NSMutableDictionary   dictionary];
    }
    return _saveTwoImageDic;
}


-(NSMutableArray *)saveImageAddress{
    if (!_saveImageAddress) {
        _saveImageAddress=[NSMutableArray array];
    }
    return _saveImageAddress;
}


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
@end
