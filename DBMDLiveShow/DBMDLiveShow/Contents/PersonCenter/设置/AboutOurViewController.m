//
//  AboutOurViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "AboutOurViewController.h"

@interface AboutOurViewController ()
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end

@implementation AboutOurViewController




- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=DBGetStringWithKeyFromTable(@"L关于我们", nil);
    self.automaticallyAdjustsScrollViewInsets=NO;
    _myTextView.userInteractionEnabled=NO;
    [self getDatas];

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


#pragma mark  --getDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_AboutOur];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            self.myTextView.text=data[@"data"];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
}
@end
