//
//  XLTabBarViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLTabBarViewController.h"
#import "XLNavigationController.h"

#import "TJPHomePageViewController.h"
//#import "MDSignedShowViewController.h"
#import "MDHotelViewController.h"
#import "PullStreamViewController.h"
#import "MDRankingViewController.h"
#import "MDPersonCenterViewController.h"




@interface XLTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation XLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor=KNaviColor;
    
    self.delegate = self;
    [self setupBasic];
}

- (void)setupBasic
{
    //首页
    [self addChildViewController:[[TJPHomePageViewController alloc] init] notmalimageNamed:@"tabBar0_normal" selectedImage:nil title:DBGetStringWithKeyFromTable(@"L旅游", nil)];
    //签约
    [self addChildViewController:[[MDHotelViewController alloc]init] notmalimageNamed:@"tabBar1_normal" selectedImage:nil title:DBGetStringWithKeyFromTable(@"L酒店", nil)];
    
    //直播
    [self addChildViewController:[[PullStreamViewController alloc] init] notmalimageNamed:@"toolbar_live" selectedImage:nil title:nil];
    //排行
    [self addChildViewController:[[MDRankingViewController alloc]init] notmalimageNamed:@"tabBar3_normal" selectedImage:nil title:DBGetStringWithKeyFromTable(@"L排名", nil)];
    
    //个人中心
    [self addChildViewController:[[MDPersonCenterViewController alloc] init] notmalimageNamed:@"tabBar4_normal" selectedImage:nil title:DBGetStringWithKeyFromTable(@"L我的", nil)];
}

- (void)addChildViewController:(UIViewController *)childController notmalimageNamed:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childController.title = title;
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : KNaviColor} forState:UIControlStateNormal];
    
    [self addChildViewController:nav];
}

#pragma mark 代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([[[viewController childViewControllers] objectAtIndex:0] isKindOfClass:[PullStreamViewController class]]){
         XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:[[PullStreamViewController alloc] init]];
        
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}
@end
