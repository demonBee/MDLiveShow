//
//  MDVideoViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/19.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MDShortVideoViewController.h"
#import "MeipaiCollectionViewCell.h"
#import "ChooseButtonCollectionReusableView.h"
#import "MeiPaiHomeModel.h"

//#import "AVPlayerViewController.h"
#import "MoviePlayerViewController.h"

#define CCELL0   @"MeipaiCollectionViewCell"
#define HEADER   @"ChooseButtonCollectionReusableView"

@interface MDShortVideoViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)DBNoDataView*noDataView;   //没有信息时候覆盖

@property(nonatomic,strong)NSMutableArray*allDatasM;  //所有model中的数据
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;

@property(nonatomic,strong)NSString*Selectedtype;   //1点赞排序 2推荐 3所有

//我的视频里面 删除判断
@property(nonatomic,assign)BOOL isDelete;

@end

@implementation MDShortVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.]
    
    self.Selectedtype=@"1";
    self.view.backgroundColor=[UIColor greenColor];
    switch (self.typee) {
        case MDShortVideoTypePageHome:
            self.title=DBGetStringWithKeyFromTable(@"L短视频", nil);
            break;
        case MDShortVideoTypeMyVedio:{
            self.title=DBGetStringWithKeyFromTable(@"L我的短视频", nil);
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 25)];
            [button setTitle:@"删除" forState:UIControlStateNormal];
            [button setTitle:@"完成" forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickDelete:)];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem=item;

        }
            break;
        case MDShortVideoTypeHotel:
//            self.title=DBGetStringWithKeyFromTable(@"L我的短视频", nil);
            break;
        default:
            break;
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;

    
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing=2;
    flowLayout.minimumLineSpacing=2;
    flowLayout.sectionInset=UIEdgeInsetsMake(0, 0, 0,0);
    flowLayout.itemSize=CGSizeMake((KScreenWidth-2)/2, (KScreenWidth-2)/2);
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor=[UIColor grayColor];
    [self.collectionView registerNib:[UINib nibWithNibName:CCELL0 bundle:nil] forCellWithReuseIdentifier:CCELL0];
    [self.collectionView registerClass:[ChooseButtonCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER];
    
    [self addRefresh];

    
    
    
    
}


#pragma mark - refresh
- (void)addRefresh {
    self.pagen=20;
    self.pages=0;
    //下拉刷新
    __weak typeof (self)weakSelf=self;
    TJPRefreshGifHeader *header = [TJPRefreshGifHeader headerWithRefreshingBlock:^{
        self.pages=0;
        if (self.typee==MDShortVideoTypePageHome) {
            [weakSelf getHomePageDatas];
        }else if(self.typee==MDShortVideoTypeMyVedio){
            [weakSelf MyVideoDatas];
            
        }else if(self.typee==MDShortVideoTypeHotel){
            [weakSelf getDatasHotel];
            
        }
        
        
        
    }];
    
    self.collectionView.mj_header = header;
    
    
    DBRefreshAutoNormalGifFooter*footer=[DBRefreshAutoNormalGifFooter footerWithRefreshingBlock:^{
        self.pages++;
        if (self.typee==MDShortVideoTypePageHome) {
            [weakSelf getHomePageDatas];
        }else if(self.typee==MDShortVideoTypeMyVedio){
            [weakSelf MyVideoDatas];
            
        }else if(self.typee==MDShortVideoTypeHotel){
            [weakSelf getDatasHotel];
            
        }
        
        
    }];
    self.collectionView.mj_footer=footer;
    
    [self.collectionView.mj_header beginRefreshing];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.noDataView.hidden=self.allDatasM.count!=0;
    return self.allDatasM.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MeipaiCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    MeiPaiHomeModel*model=self.allDatasM[indexPath.row];
    cell.mainModel=model;
    
    
    
    // 我的里面的   删除视频专用
    if (self.typee==MDShortVideoTypeMyVedio&&self.isDelete==YES) {
        cell.deleteButton.hidden=NO;
        cell.clickDeleteBlock=^(){
            MyLog(@"%lu",indexPath.row);
            [self addAlertVCWithInteger:indexPath.row];
            
            
        };
    }else if (self.typee==MDShortVideoTypeMyVedio&&self.isDelete==NO){
        cell.deleteButton.hidden=YES;
        
    }

    
    
    return cell;
}




-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.typee==MDShortVideoTypePageHome) {
        ChooseButtonCollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER forIndexPath:indexPath];
        
        
        
        header.buttonDatas=@[@"点赞",@"推荐",@"所有"];
        NSInteger num=[self.Selectedtype integerValue];
        [header.topView selectTheButton:num-1];
        header.clickButtonBlock = ^(NSInteger number) {
            MyLog(@"1..%lu",number);
            NSInteger newNumber=number+1;
            self.Selectedtype=[NSString stringWithFormat:@"%lu",newNumber];
            [self.collectionView.mj_header beginRefreshing];
            
            
        };
        
        
        
        
        
        
        return header;
        
        
    }else{
        return nil;
    }
    
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.typee==MDShortVideoTypePageHome) {
        return CGSizeMake(KScreenWidth, 44);
    }else{
        return CGSizeZero;
    }
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MeiPaiHomeModel*model=self.allDatasM[indexPath.row];
    
//    AVPlayerViewController*vc=[[AVPlayerViewController alloc]init];
//    vc.meiPaiModel=model;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    MoviePlayerViewController*vc=[[MoviePlayerViewController alloc]initWithNibName:@"MoviePlayerViewController" bundle:nil];
    vc.videoURL=[NSURL URLWithString:model.url];
    vc.meiPaiModel=model;
    vc.videoType=PlayViewTypeMeiPai;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(void)addAlertVCWithInteger:(NSInteger)selectedIndex{
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"删除" message:@"确实要删除该录像？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MeiPaiHomeModel*model=self.allDatasM[selectedIndex];
        
        [self.allDatasM removeObject:model];
        //接口
        [self getDatasDeleteWithModel:model];
        
        [self.collectionView reloadData];
        
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}



#pragma mark  --touch
-(void)clickDelete:(UIButton*)sender{
    if (!sender.selected) {
        sender.selected=YES;
        self.isDelete=YES;
        [self.collectionView reloadData];
    }else{
        sender.selected=NO;
        self.isDelete=NO;
        [self.collectionView reloadData];
        
    }
    
    
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


#pragma mark  --datas
-(void)getHomePageDatas{
  
    NSString*pagen=[NSString stringWithFormat:@"%lu",_pagen];
    NSString*pages=[NSString stringWithFormat:@"%lu",_pages];
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HomePageMeiPai];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"pagen":pagen,@"pages":pages,@"type":self.Selectedtype};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            
            if (self.pages==0) {
                [self.allDatasM removeAllObjects];
            }
            
            for (NSDictionary*dict in data[@"data"]) {
                MeiPaiHomeModel*model=[MeiPaiHomeModel yy_modelWithDictionary:dict];
                [self.allDatasM addObject:model];
            }
            
                [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:2];
        }
        
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

        
    }];
    
    
    
    
}

-(void)MyVideoDatas{
    
    NSString*pagen=[NSString stringWithFormat:@"%lu",_pagen];
    NSString*pages=[NSString stringWithFormat:@"%lu",_pages];
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_UserMeiPai];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            
            if (self.pages==0) {
                [self.allDatasM removeAllObjects];
            }
            
            for (NSDictionary*dict in data[@"data"]) {
                MeiPaiHomeModel*model=[MeiPaiHomeModel yy_modelWithDictionary:dict];
                [self.allDatasM addObject:model];
            }
            
            [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:2];
        }
        
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        
    }];
    

    
}

-(void)getDatasHotel{
    NSString*pagen=[NSString stringWithFormat:@"%lu",_pagen];
    NSString*pages=[NSString stringWithFormat:@"%lu",_pages];
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HotelMeiPai];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"pagen":pagen,@"pages":pages,@"type":@"2"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            
            if (self.pages==0) {
                [self.allDatasM removeAllObjects];
            }
            
            for (NSDictionary*dict in data[@"data"]) {
                MeiPaiHomeModel*model=[MeiPaiHomeModel yy_modelWithDictionary:dict];
                [self.allDatasM addObject:model];
            }
            
            [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:2];
        }
        
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        
    }];

    
}


//删除其中的一条美拍
-(void)getDatasDeleteWithModel:(MeiPaiHomeModel*)model{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_DEL_One_MeiPai];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"meipai_id":model.meipai_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"msg"]];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            [self.collectionView.mj_header beginRefreshing];
        }
        
        
    }];
    
    
    
}



#pragma mark-- set
-(NSMutableArray *)allDatasM{
    if (!_allDatasM) {
        _allDatasM=[NSMutableArray array];
    }
    return _allDatasM;
}

-(DBNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView=[DBNoDataView creatNoDataView];
        _noDataView.contentMode = UIViewContentModeScaleToFill;
        _noDataView.frame = self.collectionView.bounds;
        DBSelf(weakSelf);
        _noDataView.clickReloadBlock=^{
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
        [self.view insertSubview:_noDataView aboveSubview:self.collectionView];
        
    }
    return _noDataView;
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

@end
