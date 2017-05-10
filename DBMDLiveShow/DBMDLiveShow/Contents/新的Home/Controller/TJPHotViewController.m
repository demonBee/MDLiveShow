//
//  TJPHotViewController.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/8.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPHotViewController.h"
#import "TJPHotLiveItemCell.h"
#import "HotTableViewHeaderView.h"


#import "TJPRefreshGifHeader.h"

#import "NewPersonInfoModel.h"
#import "HotAdvertiseModel.h"


#import "MDLiveViewController.h"
#import "DBWebViewController.h"




static NSString * const cellID = @"liveListCell";
static NSString * const HeadCell =@"HotTableViewHeaderView";



@interface TJPHotViewController ()<UITableViewDelegate,UITableViewDataSource>


/** 数据源*/
@property(nonatomic,strong)DBNoDataView*noDataView;   //没有信息时候覆盖
@property(nonatomic,strong)UITableView*tableView;


@property (nonatomic, strong) NSMutableArray *liveDatas;
@property(nonatomic,strong)NSMutableArray*saveAdvertisementDatas;  //保存好广告

//@property (nonatomic, weak) NSTimer *timer;

@property(nonatomic,strong)NSString*type;  //筛选类型 1全部 2推荐 3关注 4签约
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;




@end

@implementation TJPHotViewController




- (NSMutableArray *)liveDatas
{
    if (!_liveDatas) {
        _liveDatas = [NSMutableArray array];
    }
    return _liveDatas;
}

-(NSMutableArray *)saveAdvertisementDatas{
    if (!_saveAdvertisementDatas) {
        _saveAdvertisementDatas=[NSMutableArray array];
    }
    return _saveAdvertisementDatas;
}








- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.type=@"2";
    self.pagen=20;
    self.pages=0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;

    
    //UI
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TJPHotLiveItemCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[HotTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:HeadCell];
    
    //数据
    [self loadData];
    //刷新
    [self addRefresh];
    //定时器
//    [self timer];
}



-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.noDataView.frame=self.tableView.bounds;
    
}


#pragma mark - Data
- (void)loadData {
    
//    NSString*urlStr=  @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HomePage];
    NSString*pagen=[NSString stringWithFormat:@"%lu",self.pagen];
    NSString*pages= [NSString stringWithFormat:@"%lu",self.pages];
//#warning 测试用
//    self.type=@"1";
    
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"type":self.type,@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        if ([pages isEqualToString:@"0"]) {
              [self.liveDatas removeAllObjects];
        }
      
        for (NSDictionary*dict in data[@"data"]) {
            NewPersonInfoModel*model= [NewPersonInfoModel yy_modelWithDictionary:dict];
            [self.liveDatas addObject:model];
        }
        
        

        //热门特有的 广告位来获取数据
        [self getAdvertisementDatas];

        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        [self.tableView reloadData];
    }];

    
    
}


-(void)getAdvertisementDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Advertisement];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [self.saveAdvertisementDatas removeAllObjects];
            
            for (NSDictionary*dict in data[@"data"]) {
                HotAdvertiseModel*model=[HotAdvertiseModel yy_modelWithDictionary:dict];
                [self.saveAdvertisementDatas addObject:model];
            }

        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.tableView reloadData];
        
    }];
    
    
}


#pragma mark - refresh
- (void)addRefresh {
    //下拉刷新
    __weak typeof (self)weakSelf=self;
    TJPRefreshGifHeader *header = [TJPRefreshGifHeader headerWithRefreshingBlock:^{
        self.pages=0;
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_header = header;
    
    
    DBRefreshAutoNormalGifFooter*footer=[DBRefreshAutoNormalGifFooter footerWithRefreshingBlock:^{
        self.pages++;
        [weakSelf loadNewData];
        
    }];
    self.tableView.mj_footer=footer;
    
}

//定时器方法
- (void)loadNewDataForHotPage {
//    TJPLog(@"timer触发"); 
    [self loadNewData];
}

//获取新数据
- (void)loadNewData {
    [self loadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  self.noDataView.hidden = _liveDatas.count != 0;
    return _liveDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJPHotLiveItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TJPHotLiveItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NewPersonInfoModel *item = _liveDatas[indexPath.row];
    cell.liveItem = item;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MDLiveViewController*vc=[[MDLiveViewController alloc]initWithAllModel:self.liveDatas andNumber:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
   
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.saveAdvertisementDatas.count>=1) {
        HotTableViewHeaderView*headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeadCell];
        headView.allDatas=self.saveAdvertisementDatas;
        headView.clickAdvertBlock=^(HotAdvertiseModel *model){
            NSString*address=model.address;
            DBWebViewController*vc=[[DBWebViewController alloc]init];
            vc.urlStr=address;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        
        return headView;
    }
    return nil;
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.saveAdvertisementDatas.count>=1) {
        return 100;
    }
    return 0.001;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KScreenHeight * 0.644;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark  --set
-(DBNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView=[DBNoDataView creatNoDataView];
        _noDataView.contentMode = UIViewContentModeScaleToFill;
        _noDataView.frame = self.tableView.bounds;
        DBSelf(weakSelf);
        _noDataView.clickReloadBlock=^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.view insertSubview:_noDataView aboveSubview:self.tableView];

    }
    return _noDataView;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



#pragma mark - 下拉的时候 隐藏的tabBar 和naviBar
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setTabBarHidden:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity < -5) {
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setTabBarHidden:YES];
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setTabBarHidden:NO];
    }else if(velocity == 0){
        //停止拖拽
    }
}



//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect tabRect = self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y = [[UIScreen mainScreen] bounds].size.height+self.tabBarController.tabBar.frame.size.height;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y = [[UIScreen mainScreen] bounds].size.height-self.tabBarController.tabBar.frame.size.height;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.tabBarController.tabBar.frame = tabRect;
    }completion:^(BOOL finished) {
        
    }];
    
}




-(void)dealloc{
//    [self.timer invalidate];
//    self.timer=nil;
}




@end
