//
//  MDSignedShowViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/13.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDSignedShowViewController.h"
#import "SSCollectionViewCell.h"
#import "AdvertShowCollectionReusableView.h"

#import "TJPRefreshGifHeader.h"
#import "NewPersonInfoModel.h"
#import "HotAdvertiseModel.h"


#import "MDLiveViewController.h"
#import "DBWebViewController.h"



#define CCELL0    @"SSCollectionViewCell"
#define CCEllHeader  @"AdvertShowCollectionReusableView"

@interface MDSignedShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)DBNoDataView*noDataView;   //没有信息时候覆盖
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *liveDatas;
@property(nonatomic,strong)NSMutableArray*saveAdvertisementDatas;  //保存好广告
@property(nonatomic,strong)NSString*type;
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;


@end

@implementation MDSignedShowViewController

-(instancetype)initWithtype:(showType)type{
    self=[super init];
    if (self) {
        self.showVC=type;
        switch (self.showVC) {
            case showTypeAll:
                self.type=@"1";
                break;
            case showTypeAttention:
                self.type=@"3";
                break;
            case showTypeSign:
                self.type=@"4";
                break;
   
            default:
                break;
        }
        
      
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;

    
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing=2;
    flowLayout.minimumInteritemSpacing=2;
    flowLayout.sectionInset=UIEdgeInsetsMake(2, 0, 2, 0);
    flowLayout.itemSize=CGSizeMake((KScreenWidth-2)/2, (KScreenWidth-2)/2);
    
    
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:CCELL0 bundle:nil] forCellWithReuseIdentifier:CCELL0];
    [self.collectionView registerClass:[AdvertShowCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CCEllHeader];
    
    
    [self addRefresh];
    [self loadData];   //第一次加载数据
    
    if ([self.type isEqualToString:@"1"]) {
        //全部特有的 广告位来获取数据
        [self getAdvertisementDatas];

    }
  
}

#pragma mark - refresh
- (void)addRefresh {
    self.pagen=20;
    self.pages=0;
    //下拉刷新
    __weak typeof (self)weakSelf=self;
    TJPRefreshGifHeader *header = [TJPRefreshGifHeader headerWithRefreshingBlock:^{
        self.pages=0;
        [weakSelf loadData];
    }];
    
    self.collectionView.mj_header = header;
    
    
    DBRefreshAutoNormalGifFooter*footer=[DBRefreshAutoNormalGifFooter footerWithRefreshingBlock:^{
        self.pages++;
        [weakSelf loadData];
        
    }];
    self.collectionView.mj_footer=footer;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    self.noDataView.hidden=self.liveDatas.count!=0;
    return self.liveDatas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    NewPersonInfoModel *item = _liveDatas[indexPath.row];
    cell.liveItem = item;

    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.saveAdvertisementDatas.count>=1&&[self.type isEqualToString:@"1"]) {
        AdvertShowCollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CCEllHeader forIndexPath:indexPath];
        header.allDatas=self.saveAdvertisementDatas;
        header.clickAdvertBlock=^(HotAdvertiseModel *model){
            NSString*address=model.address;
            DBWebViewController*vc=[[DBWebViewController alloc]init];
            vc.urlStr=address;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        
        return header;

    
    }else{
        return nil;
    }
    
  }


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   
    if (self.saveAdvertisementDatas.count>=1&&[self.type isEqualToString:@"1"]) {
         return CGSizeMake(KScreenWidth, 100);
    }else{
        return CGSizeZero;
    }
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MDLiveViewController*vc=[[MDLiveViewController alloc]initWithAllModel:self.liveDatas andNumber:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark  --getDatas

//广告这里
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
        
        
        [self.collectionView reloadData];
        
    }];
    
    
}


//第一次的时候吊用接口
- (void)loadData {
    
 
    
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
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
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

#pragma mark  --lay
-(NSMutableArray *)liveDatas{
    if (!_liveDatas) {
        _liveDatas=[NSMutableArray array];
    }
    return _liveDatas;
}

-(NSMutableArray *)saveAdvertisementDatas{
    if (!_saveAdvertisementDatas) {
        _saveAdvertisementDatas=[NSMutableArray array];
    }
    return _saveAdvertisementDatas;
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
