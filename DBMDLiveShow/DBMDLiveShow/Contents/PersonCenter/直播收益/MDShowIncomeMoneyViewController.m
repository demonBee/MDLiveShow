//
//  MyConsumeViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDShowIncomeMoneyViewController.h"
#import "YJSegmentedControl.h"
#import "MDIncomeTableViewCell.h"

#import "MDIncomeModel.h"



#define CELL0    @"MDIncomeTableViewCell"

@interface MDShowIncomeMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,assign)NSInteger type;  //时间点1今天2昨天3本月4上月
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)NSMutableArray*allDatasModel;
@property(nonatomic,strong)NSString*getMoney;   //当前时间点赚到的马币

@end

@implementation MDShowIncomeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L直播收益", nil);
    [self addChooseView];
    [self addRefresh];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MDIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
   
}

#pragma mark  -- UI
-(void)addChooseView{
    NSArray*array=@[DBGetStringWithKeyFromTable(@"L今天", nil),DBGetStringWithKeyFromTable(@"L昨天", nil),DBGetStringWithKeyFromTable(@"L本月", nil),DBGetStringWithKeyFromTable(@"L上月", nil)];
    YJSegmentedControl*view=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, KScreenWidth, 30) titleDataSource:array backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:KNaviColor buttonDownColor:KNaviColor Delegate:self];
    [self.view addSubview:view];
    
}


#pragma mark  --tableView
- (void)addRefresh {
    self.pagen=30;
    self.pages=0;
    self.type=1;
  
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
    MDIncomeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    MDIncomeModel*model=self.allDatasModel[indexPath.row];
    
    cell.model=model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*calculateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    calculateView.backgroundColor=[UIColor whiteColor];
    
    UILabel* showLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth/2, 20)];
    showLabel.font=[UIFont systemFontOfSize:14];
    showLabel.text=DBGetStringWithKeyFromTable(@"L当前总计(珍珠)", nil);;
    [calculateView addSubview:showLabel];
    
    UILabel*numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2+30, 5, KScreenWidth/2-30-40, 20)];
    numberLabel.font=[UIFont systemFontOfSize:14];
#warning 这里需要改变
    numberLabel.text=[NSString stringWithFormat:@"+%@",self.getMoney];
    [calculateView addSubview:numberLabel];
    
    return calculateView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    MyLog(@"%ld",selection);
    self.type=selection+1;
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark  -- allDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GetMoneyRecord];
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%ld",self.pages];
    //时间节点
    NSString*type=[NSString stringWithFormat:@"%ld",self.type];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"type":type,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {

          
            if (self.pages==0) {
                [self.allDatasModel removeAllObjects];
            }
            //如果paymoney 不为nil
            self.getMoney=data[@"data"][@"payMoney"];
            
            for (NSDictionary*dict in data[@"data"][@"info"]) {
                MDIncomeModel*model=[MDIncomeModel yy_modelWithDictionary:dict];
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

//假数据
//-(NSArray*)falueDatas{
//
//    NSDictionary*dict=@{@"monthDay":@"4.30",@"hourMin":@"1:30",@"WhoPayPhoto":@"http://api.zhiboquan.net/Public/Upload/20170329/14907993835584.png",@"WhoPayNick":@"黄蜂大魔王",@"giftName":@"游艇",@"giftMB":@"500.00"};
//    NSArray*array=@[dict,dict,dict,dict,dict,dict,dict,dict,dict,dict,dict,dict,dict,dict,dict,dict];
//    
//    return array;
//}


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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, KScreenWidth, KScreenHeight-64-30) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    
    return _tableView;
}


@end
