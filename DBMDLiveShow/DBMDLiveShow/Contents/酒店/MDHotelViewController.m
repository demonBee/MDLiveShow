//
//  MDHotelViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/6/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MDHotelViewController.h"
#import "TJPSegementBarVC.h"

#import "DBChooseHotelShowView.h"
#import "DBVideoViewController.h"      //回放
#import "MDShortVideoViewController.h"   //短视频


@interface MDHotelViewController ()

@property (nonatomic, weak) TJPSegementBarVC *segementBarVC;

@property(nonatomic,strong)DBChooseHotelShowView*hotelShowView;
@property(nonatomic,strong)NSMutableArray*saveCityArray;
@property(nonatomic,strong)NSString*cityName;
@property(nonatomic,strong)NSString*city_id;


@property(nonatomic,strong)NSMutableArray*searchTitleArray;

@end

@implementation MDHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = [UIColor clearColor];

    
      [self setupNavigationTitleView];
    [self creatLeftTopNavi];
    [self getcityDatas];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.segementBarVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
}


-(void)creatLeftTopNavi{
    UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [leftButton setTitle:DBGetStringWithKeyFromTable(@"L全部", nil)];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftButton addTarget:self action:@selector(clickLeftItem:)];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=item;
    
    
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


#pragma mark  --click
-(void)clickLeftItem:(UIButton*)sender{
    [self.hotelShowView getValue:self.saveCityArray];
    [self.hotelShowView show];
    DBSelf(weakSelf);
    self.hotelShowView.clickCityBlock = ^(chooseCityModel *mainModel) {
//        weakSelf.city_id=mainModel.city_id;
//        weakSelf.cityName=mainModel.city_name;
        
        NSDictionary*dict=@{@"city_name":mainModel.city_name,@"city_id":mainModel.city_id};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseCity" object:nil userInfo:dict];
        
        [sender setTitle:mainModel.city_name];
        
        
    };
    

    
    
}


#pragma mark  --datas
-(void)getcityDatas{
   self.saveCityArray=[NSMutableArray array];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_CountryCityList];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            NSArray*array=data[@"data"];
            for (NSDictionary*dict in array) {
                chooseCityModel*model=[chooseCityModel yy_modelWithDictionary:dict];
                
                [self.saveCityArray addObject:model];
            }

            
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


-(DBChooseHotelShowView *)hotelShowView{
    if (!_hotelShowView) {
        _hotelShowView=[DBChooseHotelShowView chooseHotelShowView];
        [[UIApplication sharedApplication].keyWindow addSubview:_hotelShowView];
    }
    return _hotelShowView;
}

@end
