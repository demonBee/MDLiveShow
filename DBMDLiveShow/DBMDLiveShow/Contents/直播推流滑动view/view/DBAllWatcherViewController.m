//
//  DBAllWatcherViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBAllWatcherViewController.h"
#import "DBFansTableViewCell.h"

//#import "DBUserPersonView.h"
#import "DBShowInfoView.h"

#define CELL0   @"DBFansTableViewCell"

@interface DBAllWatcherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
//@property(nonatomic,strong)DBUserPersonView*userPersonView;  //用户个人中心view
@property(nonatomic,strong)DBShowInfoView*showInfoView;

@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;

@end

@implementation DBAllWatcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
     [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self addRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden=NO;
    
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.userPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(@0);
//        make.width.offset(302);
//        make.height.offset(410);
//    }];
    
    
}

- (void)addRefresh {
    self.pagen=30;
    self.pages=0;
    
    
    //下拉刷新
    __weak typeof (self)weakSelf=self;
    TJPRefreshGifHeader *header = [TJPRefreshGifHeader headerWithRefreshingBlock:^{
        _pages=0;
        [self getDatas];
    }];
    
    self.tableView.mj_header = header;
    
    
    DBRefreshAutoNormalGifFooter*footer=[DBRefreshAutoNormalGifFooter footerWithRefreshingBlock:^{
        _pages++;
        [self getDatas];
    }];
    self.tableView.mj_footer=footer;
    [self.tableView.mj_header beginRefreshing];
}





#pragma mark  -- datas
-(void)getDatas{
    NSString*pages=[NSString stringWithFormat:@"%lu",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%lu",self.pagen];
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_watcherList];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"anchor_id":_mainModel.ID,@"pages":pages,@"pagen":pagen};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] integerValue]==0) {
            if (self.pages==0) {
                [self.allDatas removeAllObjects];
            }
            
            for (NSDictionary*dict in data[@"data"][@"lists"]) {
                NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithDictionary:dict];
                [self.allDatas addObject:model];
                
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBFansTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selected=NO;
    cell.backgroundColor=DBColor(231, 231, 231);
    NewPersonInfoModel*model=self.allDatas[indexPath.row];
    cell.modelItem=model;
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NewPersonInfoModel*model=self.allDatas[indexPath.row];
    [self clickUser:model];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch


- (void)clickUser:(NewPersonInfoModel *)model {
    
    self.showInfoView.mainModel=model;
    [self.showInfoView show];
    
    
}



#pragma mark  -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


-(DBShowInfoView *)showInfoView{
    if (!_showInfoView) {
        _showInfoView=[DBShowInfoView showInfoViewInView:self.view];
    }
    return _showInfoView;
}


//-(DBUserPersonView *)userPersonView{
//    if (!_userPersonView) {
//        _userPersonView=[DBUserPersonView creatDBUserPersonView];
//        _userPersonView.hidden=YES;
//        _userPersonView.transform=CGAffineTransformMakeScale(0.01, 0.01);
//        [self.view addSubview:_userPersonView];
//        DBSelf(weakSelf);
//        [_userPersonView setCloseViewBlock:^{
//            [UIView animateWithDuration:0.25 animations:^{
//                weakSelf.userPersonView.hidden = YES;
//                weakSelf.userPersonView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//            } completion:nil];
//        }];
//        
//        
//        
//    }
//    return _userPersonView;
//    
//}


-(NSMutableArray *)allDatas{
    if (!_allDatas) {
        _allDatas=[NSMutableArray array];
    }
    return _allDatas;
}

@end
