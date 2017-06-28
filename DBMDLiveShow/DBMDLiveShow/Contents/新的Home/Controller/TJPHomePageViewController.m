//
//  TJPHomePageViewController.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPHomePageViewController.h"
#import "TJPSegementBarVC.h"

#import "MDSignedShowViewController.h"   //直播
#import "TJPHotViewController.h"
#import "DBVideoViewController.h"      //回放
#import "MDShortVideoViewController.h"   //短视频

#import "PYSearch.h"  //搜索功能
#import "DBSearchViewController.h"

//引导页和广告页
#import "AppDelegate+DBDefault.h"
#import "AdvertiseViewController.h"

@interface TJPHomePageViewController ()<PYSearchViewControllerDelegate>

@property (nonatomic, weak) TJPSegementBarVC *segementBarVC;


@property(nonatomic,strong)NSMutableArray*searchTitleArray;

@end

@implementation TJPHomePageViewController


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


//appDelegate 中的设置
-(void)AppDelegateSet{
    // 第一次使用
    [AppDelegate isFirstOPen];
    
    //广告栏
    [AppDelegate makeAdvertComplete:^(NSString *addressStr) {
        MyLog(@"%@",addressStr);
        AdvertiseViewController *adVc = [[AdvertiseViewController alloc] init];
        adVc.adUrl=addressStr;
        [self.navigationController pushViewController:adVc animated:YES];
        
        
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];

//appDelegate 中的设置
    [self AppDelegateSet];
    
   
    
    
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = [UIColor clearColor];

    
    [self setupNavigationTitleView];
    [self setupNavigationItem];

    //得到搜索关键字的接口
    [self getSearchTitleDatas];
 
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
    
    MDSignedShowViewController *allVC = [[MDSignedShowViewController alloc] initWithtype:showTypeAll];
    
//    TJPHotViewController *hotVC = [[TJPHotViewController alloc] init];
//    MDSignedShowViewController *attentionVC = [[MDSignedShowViewController alloc] initWithtype:showTypeAttention];
    
    DBVideoViewController*videoVC=[[DBVideoViewController alloc]init];
    videoVC.typee=videoTypeRecommendVedio;
    
    MDShortVideoViewController*MDShortVC=[[MDShortVideoViewController alloc]init];
    MDShortVC.typee=MDShortVideoTypePageHome;
    
//DBGetStringWithKeyFromTable(@"L热门", nil),DBGetStringWithKeyFromTable(@"L关注", nil),DBGetStringWithKeyFromTable(@"L视频", nil),
//     hotVC, attentionVC,MDVC,
    
    [self.segementBarVC setUpWithItems:@[DBGetStringWithKeyFromTable(@"L直播", nil), DBGetStringWithKeyFromTable(@"L回放", nil),DBGetStringWithKeyFromTable(@"L短视频", nil)] childVCs:@[allVC,videoVC,MDShortVC]];
    
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


#warning 先隐藏搜索和私信两个按钮
- (void)setupNavigationItem {
    
  
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"title_button_search" highImage:@"title_button_search" target:self andAction:@selector(search)];
//    //right item
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"title_button_more" highImage:@"title_button_more" target:self andAction:@selector(more)];

    
    
}





#pragma mark - 方法实现
- (void)search {
    

    //接口 获取 热门主播
//  NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
   
    
    NSArray *hotSeaches;
    if (self.searchTitleArray.count>0) {
        hotSeaches=[self.searchTitleArray copy];
    }else{
       
    }
    
    PYSearchViewController *searchViewController =[PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"通过房间号，房间名，主播名 搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        DBSearchViewController*vc=[[DBSearchViewController alloc]init];
        vc.searchKey=searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
        
        
    }];
    searchViewController.hotSearchStyle=PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle=PYSearchHistoryStyleCell;
    searchViewController.delegate=self;
    [self.navigationController pushViewController:searchViewController animated:YES];
    
    
}

- (void)more {
    
//    TJPLogFunc
    
}


#pragma mark  -- datas
-(void)getSearchTitleDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SearchTitle];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [self.searchTitleArray removeAllObjects];
            for (NSDictionary*dict in data[@"data"]) {
                [self.searchTitleArray addObject:dict[@"title"]];
                
            }
            
            
            
        }else{
            
        }
        
    }];
    
    
}

#pragma mark -- set
-(NSMutableArray *)searchTitleArray{
    if (!_searchTitleArray) {
        _searchTitleArray=[NSMutableArray array];
    }
    return _searchTitleArray;
}


@end
