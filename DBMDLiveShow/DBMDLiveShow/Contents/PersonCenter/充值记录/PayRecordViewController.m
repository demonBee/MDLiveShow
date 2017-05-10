//
//  PayRecordViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "PayRecordViewController.h"
#import "PayRecordTableViewCell.h"
#import "PayRecordModel.h"

#define CELL0   @"PayRecordTableViewCell"

@interface PayRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)NSMutableArray*allDatasModel;


@end

@implementation PayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=DBGetStringWithKeyFromTable(@"L充值记录", nil);
    [self addRefresh];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
}

#pragma mark  --tableView
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatasModel.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayRecordTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    PayRecordModel*model=self.allDatasModel[indexPath.row];
    cell.mainModel=model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



#pragma mark  -- allDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PayRecords];
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%ld",self.pages];

    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"pagen":pagen,@"pages":pages};

    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
#warning 假数据
            
            if (self.pages==0) {
                [self.allDatasModel removeAllObjects];
            }

           
            for (NSDictionary*dict in data[@"data"]) {
                PayRecordModel*model=[PayRecordModel yy_modelWithDictionary:dict];
                [self.allDatasModel addObject:model];
                
            }
            
            
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];

        
        
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


#pragma mark  --set
-(NSMutableArray *)allDatasModel{
    if (!_allDatasModel) {
        _allDatasModel=[NSMutableArray array];
    }
    return _allDatasModel;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    
    return _tableView;
}

@end
