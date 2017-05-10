//
//  MDRankingViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/13.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDRankingViewController.h"
#import "ThreeShowTableViewCell.h"
#import "OtherShowTableViewCell.h"

#import "NewPersonInfoModel.h"



#define CELL0     @"ThreeShowTableViewCell"
#define CELL1     @"OtherShowTableViewCell"

@interface MDRankingViewController ()<YJSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

//@property(nonatomic,strong)NSMutableArray*allDatasModel;   //所有数据
@property(nonatomic,strong)NSMutableArray*topAlldatasModel;  //顶部最多3个
@property(nonatomic,strong)NSMutableArray*bottomAllDatasModel; //底部数据


@property(nonatomic,assign)NSInteger identity;    //身份   0为消费者 1为主播
@property(nonatomic,assign)NSInteger timeSort;   //时间   1  2  3  4
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;





@end

@implementation MDRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeNavi];
    [self makeTopView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    
    [self addRefresh];

}

#pragma mark  --  UI
-(void)makeNavi{
    self.timeSort=1;
    self.identity=0;
    
    UISegmentedControl*segmentView=[[UISegmentedControl alloc]initWithItems:@[DBGetStringWithKeyFromTable(@"L土豪榜", nil),DBGetStringWithKeyFromTable(@"L主播榜", nil)]];
    segmentView.frame=CGRectMake(0, 0, KScreenWidth/2, 30);
    [segmentView addTarget:self action:@selector(didClickSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView=segmentView;
    segmentView.selectedSegmentIndex=0;
   

    
}


-(void)makeTopView{
    NSArray*array=@[DBGetStringWithKeyFromTable(@"L日榜", nil),DBGetStringWithKeyFromTable(@"L周榜", nil),DBGetStringWithKeyFromTable(@"L月榜", nil),DBGetStringWithKeyFromTable(@"L总榜", nil)];
  
    YJSegmentedControl*YJview=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, KScreenWidth, 30) titleDataSource:array backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:17] selectColor:KNaviColor buttonDownColor:KNaviColor Delegate:self];
    [self.view addSubview:YJview];
    
}



- (void)addRefresh {
    self.pagen=10;
    self.pages=0;
    //下拉刷新
//    __weak typeof (self)weakSelf=self;
    TJPRefreshGifHeader *header = [TJPRefreshGifHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewData];
        self.pages=0;
        [self getDatas];
        
    }];
    
    self.tableView.mj_header = header;
    
    
    DBRefreshAutoNormalGifFooter*footer=[DBRefreshAutoNormalGifFooter footerWithRefreshingBlock:^{
        self.pages++;
        [self getDatas];

        
    }];
    self.tableView.mj_footer=footer;
    
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.topAlldatasModel.count==0) {
        return 0;
    }else{
        if (self.bottomAllDatasModel.count==0) {
            return 1;
        }else{
            return 2;
        }
        
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.topAlldatasModel.count;
    }else{
        return self.bottomAllDatasModel.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ThreeShowTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        NewPersonInfoModel*model=self.topAlldatasModel[indexPath.row];
        
        //等级
        switch (indexPath.row) {
            case 0:
                cell.levelImage.image=[UIImage imageNamed:@"rank_1"];
                break;
            case 1:
                cell.levelImage.image=[UIImage imageNamed:@"rank_2"];
                break;
            case 2:
                cell.levelImage.image=[UIImage imageNamed:@"rank_3"];
                break;
   
            default:
                break;
        }
        //头像
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        cell.nameLabel.text=model.nick;
        //主播还是土豪等级
        switch (self.identity) {
            case 0:
                //土豪
                [cell.levelButton setImage:[UIImage imageNamed:@"皇冠"] forState:UIControlStateNormal];
                [cell.levelButton setTitle:model.watcherLevel forState:UIControlStateNormal];
                cell.detailLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L消费：%@", nil),model.totailPayMoney];
                break;
            case 1:
                //主播
                [cell.levelButton setImage:[UIImage imageNamed:@"钻石"] forState:UIControlStateNormal];
                [cell.levelButton setTitle:model.LiveLevel forState:UIControlStateNormal];
                 cell.detailLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L收礼：%@", nil),model.totailLiveGetMoney];
                break;
     
            default:
                break;
        }
        
        
        
        
        return cell;
    }else{
        OtherShowTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
         cell.selectionStyle=NO;
        NewPersonInfoModel*model=self.bottomAllDatasModel[indexPath.row];
        
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        cell.nameLabel.text=model.nick;
        //主播还是土豪等级
        switch (self.identity) {
            case 0:
                //土豪
                [cell.levelButton setImage:[UIImage imageNamed:@"皇冠"] forState:UIControlStateNormal];
                [cell.levelButton setTitle:model.watcherLevel forState:UIControlStateNormal];
                cell.detailLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L消费：%@", nil),model.totailPayMoney];
                break;
            case 1:
                //主播
                [cell.levelButton setImage:[UIImage imageNamed:@"钻石"] forState:UIControlStateNormal];
                [cell.levelButton setTitle:model.LiveLevel forState:UIControlStateNormal];
                cell.detailLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L收礼：%@", nil),model.totailLiveGetMoney];                break;
                
            default:
                break;
        }
        
     
        
        
        
        return cell;
    }
    
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 140;
    }else{
        return 70;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


#pragma mark  --  getDatas
-(void)getDatas{
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
    
    NSString*urlStr;
    if (self.identity==0) {
        //土豪榜
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_richmanList];
    }else{
        //主播
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_BGList];
    }
    
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%ld",self.pages];
    //时间节点
    NSString*type=[NSString stringWithFormat:@"%ld",self.timeSort];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"type":type,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {

            [self.topAlldatasModel removeAllObjects];
            if (self.pages==0) {
                [self.bottomAllDatasModel removeAllObjects];
            }
            
            

            NSArray*topThree=data[@"data"][@"topThree"];
            for (NSDictionary*dict in topThree) {
                NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithDictionary:dict];
                [self.topAlldatasModel addObject:model];
            }
           
            
            
            NSArray*pagesTen=data[@"data"][@"pagesTen"];
            for (NSDictionary*dict in pagesTen) {
                NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithDictionary:dict];
                [self.bottomAllDatasModel addObject:model];

            }
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }];
    
    
    
}


////假数据
//-(NSDictionary*)falueDatas{
//    //土豪榜前三  3个model2 model2需要多添加2个字段totailPayMoney总共花费的钱，totailLiveGetMoney 直播总共转到的钱
//    //topThree 只有3个 而且不管pages 多少 都不变。 pages 只变下面的pagesTen 里面的数据
//    NSDictionary*model2=@{@"totailPayMoney":@"1000",@"totailLiveGetMoney":@"9999",@"nick":@"大司马",@"portrait":@"http://api.zhiboquan.net/Public/Upload/20170329/14907993835584.png",@"LiveLevel":@"60",@"watcherLevel":@"30"};
//    NSArray*topThree=@[model2,model2,model2];
//    NSArray*pagesTen=@[model2,model2,model2,model2,model2,model2,model2,model2,model2,model2];
//    NSDictionary*dict=@{@"topThree":topThree,@"pagesTen":pagesTen};
//    
//    return dict;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark  --  delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    self.timeSort=selection+1;
 
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark  --  touch
-(void)didClickSegment:(UISegmentedControl*)segmentedControl{
  NSInteger number =segmentedControl.selectedSegmentIndex;
    self.identity=number;
     [self.tableView.mj_header beginRefreshing];
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



-(NSMutableArray *)topAlldatasModel{
    if (!_topAlldatasModel) {
        _topAlldatasModel=[NSMutableArray array];
    }
    return _topAlldatasModel;
}

-(NSMutableArray *)bottomAllDatasModel{
    if (!_bottomAllDatasModel) {
        _bottomAllDatasModel=[NSMutableArray array];
    }
    return _bottomAllDatasModel;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, KScreenWidth, KScreenHeight-64-30-49) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


@end
