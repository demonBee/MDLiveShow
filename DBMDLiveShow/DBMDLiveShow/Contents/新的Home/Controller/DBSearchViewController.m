//
//  DBSearchViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/26.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBSearchViewController.h"
#import "SSCollectionViewCell.h"

#import "TJPRefreshGifHeader.h"
#import "NewPersonInfoModel.h"


#import "MDLiveViewController.h"

@interface DBSearchViewController ()
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)DBNoDataView*noDataView;   //没有信息时候覆盖



@property(nonatomic,strong)NSMutableArray*allDatasM;


@end

#define CCELL0    @"SSCollectionViewCell"

@implementation DBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L搜索结果", nil);
    self.view.backgroundColor=[UIColor greenColor];
    [self getDatas];
    
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
    
   
    
}



#pragma mark  --UI
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.noDataView.hidden=self.allDatasM.count!=0;
    return self.allDatasM.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    NewPersonInfoModel *item = self.allDatasM[indexPath.row];
    cell.liveItem = item;
    if ([item.isliving isEqualToString:@"0"]) {
        cell.liveLabel.text=DBGetStringWithKeyFromTable(@"L未直播", nil);
    }else if ([item.isliving isEqualToString:@"1"]){
        cell.liveLabel.text=DBGetStringWithKeyFromTable(@"L直播中", nil);
    }
  
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MDLiveViewController*vc=[[MDLiveViewController alloc]initWithAllModel:self.allDatasM andNumber:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark--  getDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Search];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"keyword":self.searchKey,@"pagen":@"1000",@"pages":@"0"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [self.allDatasM removeAllObjects];
            
            for (NSDictionary*dict in data[@"data"]) {
                NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithDictionary:dict];
                [self.allDatasM addObject:model];
                
                
            }
            
            [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
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
            [weakSelf getDatas];
        };
        [self.view insertSubview:_noDataView aboveSubview:self.collectionView];
        
    }
    return _noDataView;
}


@end
