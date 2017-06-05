//
//  DBWebViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBWebViewController.h"

@interface DBWebViewController ()

@end

@implementation DBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    MyLog(@"%@",self.urlStr);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [self.webView loadRequest:request];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
//    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
      [self.navigationController setNavigationBarHidden:NO animated:NO];
}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
//    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//  [self.navigationController setNavigationBarHidden:NO animated:NO];
//    
//}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
    
//     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
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
- (UIWebView *)webView
{
    if (_webView == nil){
        
        UIWebView *webView = [[UIWebView alloc] init];
        
        [self.view addSubview:webView];
        
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.view);
            make.height.equalTo(self.view);
            make.center.equalTo(self.view);
        }];
        
        _webView = webView;
    }
    return _webView;
}




@end
