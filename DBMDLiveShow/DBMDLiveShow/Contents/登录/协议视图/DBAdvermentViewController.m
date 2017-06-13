//
//  DBAdvermentViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/13.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBAdvermentViewController.h"

@interface DBAdvermentViewController ()

@end

@implementation DBAdvermentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"注册协议";
    
    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:textView];
    textView.text=[self getText];
    
    
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


-(NSString*)getText{

    NSError *error;
    NSString*path=[[NSBundle mainBundle]pathForResource:@"adverment" ofType:@"txt"];
    NSString*str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    
    if (str) {
        return str;
    }
    
    
    
    return nil;
}




@end
