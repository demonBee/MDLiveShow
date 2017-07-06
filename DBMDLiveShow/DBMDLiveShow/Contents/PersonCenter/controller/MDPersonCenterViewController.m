//
//  MDPersonCenterViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/13.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDPersonCenterViewController.h"
#import "MDPCHeaderCollectionReusableView.h"
#import "PersonCenterMainViewCCell.h"
#import "NewPersonInfoModel.h"


#import "FollowFansViewController.h"   //关注粉丝
#import "PersonInfoViewController.h"   //个人资料
#import "MDSettingViewController.h"   //设置
#import "FeedBackViewController.h"    //反馈
#import "MDLevelViewController.h"      //等级
#import "PrePaidViewController.h"     //充值
#import "MyConsumeViewController.h"    //消费记录
#import "MDShowIncomeMoneyViewController.h"  //直播收益
#import "PayRecordViewController.h"   //充值记录
#import "DBVideoViewController.h"   //我的回放
#import "MDShortVideoViewController.h"
#import "DBBlackListViewController.h"

#define CCELL0   @"PersonCenterMainViewCCell"
#define HEADER   @"MDPCHeaderCollectionReusableView"

@interface MDPersonCenterViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView*collectionView;

@property(nonatomic,strong)NSArray*collectionViewDatas;
@property(nonatomic,strong)NewPersonInfoModel*personModel;


@end

@implementation MDPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"";
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithImage:@"修改资料" highImage:nil target:self andAction:@selector(touchRightItem)];
    
    [self setUpCollectionView];
    
    [self locateDatas];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    [self getDatas];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}


#pragma mark  -- UI
-(void)setUpCollectionView{
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=10;
    flowLayout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    flowLayout.itemSize=CGSizeMake(90, 90);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView registerNib:[UINib nibWithNibName:CCELL0 bundle:nil] forCellWithReuseIdentifier:CCELL0];
    [self.collectionView registerNib:[UINib nibWithNibName:HEADER bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER];
   
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
  
    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewDatas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict=self.collectionViewDatas[indexPath.row];
    
    PersonCenterMainViewCCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];


    
    cell.imageView.image=[UIImage imageNamed:dict[@"image"]];
    cell.label.text=dict[@"title"];
    

 
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row==0) {
        //消费
        MyConsumeViewController*vc=[[MyConsumeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==1){
        //直播收益
        MDShowIncomeMoneyViewController*vc=[[MDShowIncomeMoneyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==2){
        //等级
        MDLevelViewController*vc=[[MDLevelViewController alloc]initWithNibName:@"MDLevelViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.row==3){
        //充值
        PrePaidViewController*vc=[[PrePaidViewController alloc]initWithDatas:self.personModel];
        [self.navigationController pushViewController:vc animated:YES];
//        [JRToast showWithText:@"充值暂未开放，请签到分享获取马币"];
        
    }
    else if (indexPath.row==4){
        //反馈
        FeedBackViewController*vc=[[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.row==5){
        //设置
        MDSettingViewController*vc=[[MDSettingViewController alloc]init];
        vc.personModel=self.personModel;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row==6){
        //充值记录
        PayRecordViewController*vc=[[PayRecordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==7){
        //我的回放
        DBVideoViewController*vc=[[DBVideoViewController alloc]init];
        vc.typee=videoTypeMyVedio;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==8){
        //我的短视频
        MDShortVideoViewController*vc=[[MDShortVideoViewController alloc]init];
        vc.typee=MDShortVideoTypeMyVedio;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==9){
        //我的黑名单
        DBBlackListViewController*vc=[[DBBlackListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
}






-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MDPCHeaderCollectionReusableView*reusable=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER forIndexPath:indexPath];
    reusable.model=self.personModel;

    //两个点击事项
    reusable.followBlock=^(){

        FollowFansViewController*vc=[FollowFansViewController creatVCWith:FollowFansVCFollow];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    reusable.fansBlock=^(){
      
        FollowFansViewController*vc=[FollowFansViewController creatVCWith:FollowFansVCFans];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    
    return reusable;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 300);
}






#pragma mark  -- touch
-(void)touchRightItem{
    PersonInfoViewController*vc=[[PersonInfoViewController alloc]initWithDatas:self.personModel];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark  -- Datas
-(void)locateDatas{
    NSDictionary*dict0=@{@"image":@"pc_icon0",@"title":DBGetStringWithKeyFromTable(@"L消费", nil)};
    NSDictionary*dict1=@{@"image":@"pc_icon1",@"title":DBGetStringWithKeyFromTable(@"L直播收益", nil)};
    NSDictionary*dict2=@{@"image":@"pc_icon2",@"title":DBGetStringWithKeyFromTable(@"L等级", nil)};
    NSDictionary*dict3=@{@"image":@"pc_icon3",@"title":DBGetStringWithKeyFromTable(@"L充值", nil)};
    NSDictionary*dict4=@{@"image":@"pc_icon4",@"title":DBGetStringWithKeyFromTable(@"L反馈", nil)};
    NSDictionary*dict5=@{@"image":@"pc_icon5",@"title":DBGetStringWithKeyFromTable(@"L设置", nil)};
    NSDictionary*dict6=@{@"image":@"pc_icon6",@"title":DBGetStringWithKeyFromTable(@"L充值记录", nil)};
    NSDictionary*dict7=@{@"image":@"pc_icon7",@"title":DBGetStringWithKeyFromTable(@"L我的回放", nil)};
    NSDictionary*dict8=@{@"image":@"pc_icon8",@"title":DBGetStringWithKeyFromTable(@"L我的短视频", nil)};
    
    NSDictionary*dict9=@{@"image":@"pc_icon9",@"title":DBGetStringWithKeyFromTable(@"L我的黑名单", nil)};
    
    //,dict3
    self.collectionViewDatas=@[dict0,dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9];
    
}


#warning 这里 可以用 model1 的接口
//通过user_id 得到自己的所有资料
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_personCenter];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);

        if ([data[@"errorCode"] integerValue]==0) {
            NSDictionary*dict=data[@"data"];
            
            NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithDictionary:dict];
            self.personModel=model;
            [self.collectionView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        
        
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
