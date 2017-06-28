//
//  MDHotelViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MDHotelViewController.h"
#import "TJPSegementBarVC.h"

#import "DBVideoViewController.h"      //回放
#import "MDShortVideoViewController.h"   //短视频


@interface MDHotelViewController ()

@property (nonatomic, weak) TJPSegementBarVC *segementBarVC;


@property(nonatomic,strong)NSMutableArray*searchTitleArray;

@end

@implementation MDHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = [UIColor clearColor];

    
      [self setupNavigationTitleView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.segementBarVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
}


- (void)setupNavigationTitleView {
    
    
    self.segementBarVC.segementBar.frame = CGRectMake(0, 0, 265, 35);
    self.navigationItem.titleView = self.segementBarVC.segementBar;
    
    self.segementBarVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.view addSubview:self.segementBarVC.view];
    
    
    
    
    
    DBVideoViewController*videoVC=[[DBVideoViewController alloc]init];
    videoVC.typee=videoTypeHotel;
    
    MDShortVideoViewController*MDShortVC=[[MDShortVideoViewController alloc]init];
    MDShortVC.typee=MDShortVideoTypeHotel;
    
    
    [self.segementBarVC setUpWithItems:@[DBGetStringWithKeyFromTable(@"L酒店回放", nil), DBGetStringWithKeyFromTable(@"L酒店短视频", nil)] childVCs:@[videoVC,MDShortVC]];
    
    //设置属性相关
    self.segementBarVC.segementBar.selectIndex=0;
    
    [self.segementBarVC.segementBar updateWithConfig:^(TJPSegementBarConfig *config) {
        config.segementBarBackColor = [UIColor clearColor];
        config.itemNormalColor = [UIColor whiteColor];
        config.itemSelectedColor = [UIColor whiteColor];
        config.indicatorColor = [UIColor whiteColor];
        config.indicatorExtraW = -10;
        
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

#pragma mark - lazy
- (TJPSegementBarVC *)segementBarVC
{
    if (!_segementBarVC) {
        TJPSegementBarVC *vc = [[TJPSegementBarVC alloc] init];
        vc.view.backgroundColor=[UIColor whiteColor];
        [self addChildViewController:vc];
        _segementBarVC = vc;
    }
    return _segementBarVC;
}


@end
