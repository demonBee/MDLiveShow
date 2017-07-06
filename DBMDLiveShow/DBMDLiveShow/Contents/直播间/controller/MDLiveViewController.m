//
//  MDLiveViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/2/7.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDLiveViewController.h"
#import "LivingRoomCollectionViewCell.h"
#import "DBLiveBGViewController.h"
//#import "DBUserPersonView.h"
#import "DBShowInfoView.h"

#import "NewPersonInfoModel.h"

#import "DBAllWatcherViewController.h"

#define CCELL0   @"LivingRoomCollectionViewCell"
@interface MDLiveViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView*collectionView;
//@property(nonatomic,strong)DBUserPersonView*userPersonView;  //用户个人中心view
@property(nonatomic,strong)DBShowInfoView*userInfoView;

@property(nonatomic,strong)DBLiveBGViewController*BGVC;


@property(nonatomic,strong)NSArray*allDatasModel;
@property(nonatomic,assign)NSInteger number;

@end

@implementation MDLiveViewController

-(instancetype)initWithAllModel:(NSArray*)allModel andNumber:(NSInteger)number{
    self=[super init];
   
    self.allDatasModel=allModel;
    self.number=number;
    


    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self makeCollectionView];
    //上面添加一个可侧滑的控制器
    self.BGVC.liveItem=self.allDatasModel[self.number];
    [self.view insertSubview:self.BGVC.view aboveSubview:self.collectionView];
    [self addChildViewController:self.BGVC];
    
    //添加通知  查看个人观众的个人中心
    [self addObserve];

}




-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.userPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(@0);
//        make.width.offset(302);
//        make.height.offset(410);
//    }];

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
    
}


#pragma mark  -- UI
-(void)makeCollectionView{
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.itemSize=self.view.bounds.size;
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LivingRoomCollectionViewCell class] forCellWithReuseIdentifier:CCELL0];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LivingRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    cell.parentVc = self;
    cell.liveItem = self.allDatasModel[self.number];
       
    return cell;
}

#pragma mark - 通知相关
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kNotificationClickUser object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickRoomNumber:) name:KNotificationTwo object:nil];
    
}


- (void)clickUser:(NSNotification *)notification {
    
    if (notification.userInfo[@"info"]) {
        
//        NewPersonInfoModel *userItem = notification.userInfo[@"info"];
//        self.userPersonView.mainModel=userItem;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.userPersonView.hidden = NO;
//            self.userPersonView.transform = CGAffineTransformIdentity;
//        }];
        
        
        NewPersonInfoModel *userItem = notification.userInfo[@"info"];
        self.userInfoView.mainModel=userItem;
        if ([_BGVC.chatVC.targetId isEqualToString:[UserSession instance].user_id]) {
             self.userInfoView.isLiverTouch=YES;
            
        }else{
             self.userInfoView.isLiverTouch=NO;
        }

        [self.userInfoView show];
        
        
    }
    
        
        
}


-(void)clickRoomNumber:(NSNotification*)notification{
    if (notification.userInfo[@"info"]) {
        NewPersonInfoModel*userItem=notification.userInfo[@"info"];
        DBAllWatcherViewController*vc=[[DBAllWatcherViewController alloc]init];
        vc.mainModel=userItem;
        if ([_BGVC.chatVC.targetId isEqualToString:[UserSession instance].user_id]) {
            vc.isAnchorClick=YES;
            
        }else{
            vc.isAnchorClick=NO;
        }

        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}






- (void)removeObserve {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self removeObserve];


    
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

-(DBLiveBGViewController *)BGVC{
    if (!_BGVC) {
        _BGVC=[[DBLiveBGViewController alloc]initWithDatas:nil andliveType:LiveRoomTypeWatch andSuperVC:self];
        _BGVC.view.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
               
    }
    return _BGVC;
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


-(DBShowInfoView *)userInfoView{
    if (!_userInfoView) {
        _userInfoView=[DBShowInfoView showInfoViewInView:self.view];
        
        
    }
    
    return _userInfoView;
}


@end
