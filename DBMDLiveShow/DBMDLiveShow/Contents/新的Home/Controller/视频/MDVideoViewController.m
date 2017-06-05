//
//  MDVideoViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/19.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MDVideoViewController.h"
#import "YJSegmentedControl.h"

@interface MDVideoViewController ()<YJSegmentedControlDelegate>

@end

@implementation MDVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.]
    self.view.backgroundColor=[UIColor greenColor];
    //
    [self addTopChooseView];
    
}

-(void)addTopChooseView{
    NSArray*titleDatas=@[@"马累",@"瓦杜岛",@"阿里拉岛",@"安娜塔娜迪古岛",@"卡尼岛",@"安娜塔娜迪古岛",@"安娜塔娜迪古岛",@"安娜塔娜迪古岛"];
    YJSegmentedControl*topView=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 0, KScreenWidth, 44) titleDataSource:titleDatas backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:KNaviColor buttonDownColor:KNaviColor Delegate:self];
    [self.view addSubview:topView];
    
 
    
}



#pragma mark  --  delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    MyLog(@"%lu",selection);

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

@end
