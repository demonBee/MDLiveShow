//
//  FollowFansViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "FollowFansViewController.h"
#import "DBFansTableViewCell.h"

#import "FollowFansModel.h"




#define CELL0   @"DBFansTableViewCell"
@interface FollowFansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,assign)FollowFansVC followOrFans;  //关注还是粉丝

@property(nonatomic,strong)NSMutableArray*allDatasModel;  //所有数据


@end

@implementation FollowFansViewController

+(instancetype)creatVCWith:(FollowFansVC)aa{
    FollowFansViewController*vc=[[self alloc]init];
    vc.followOrFans=aa;
    
    switch (aa) {
        case FollowFansVCFollow:
            vc.title=DBGetStringWithKeyFromTable(@"L关注", nil);
            break;
        case FollowFansVCFans:
            vc.title=DBGetStringWithKeyFromTable(@"L粉丝", nil);
            break;
    
        default:
            break;
    }
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self addRefresh];
    
    
}

#pragma mark  --tableView
#pragma mark  --tableView
- (void)addRefresh {
    self.pagen=30;
    self.pages=0;
  
    
    //下拉刷新
    __weak typeof (self)weakSelf=self;
    TJPRefreshGifHeader *header = [TJPRefreshGifHeader headerWithRefreshingBlock:^{
        _pages=0;
        //得到数据
        switch (self.followOrFans) {
            case FollowFansVCFollow:{
                [self getFollowDatas];
                break;}
            case FollowFansVCFans:{
                [self getFansDatas];
                break;}
                
            default:
                break;
        }

    }];
    
    self.tableView.mj_header = header;
    
    
    DBRefreshAutoNormalGifFooter*footer=[DBRefreshAutoNormalGifFooter footerWithRefreshingBlock:^{
        _pages++;
        //得到数据
        switch (self.followOrFans) {
            case FollowFansVCFollow:{
                [self getFollowDatas];
                break;}
            case FollowFansVCFans:{
                [self getFansDatas];
                break;}
                
            default:
                break;
        }

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
    DBFansTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    FollowFansModel*model=self.allDatasModel[indexPath.row];
    
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.Photo] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    cell.NameLabel.text=model.nick;
    cell.FansLabel.text=model.ownFans;
    
    
   
    [cell.followButton setTitle:DBGetStringWithKeyFromTable(@"L关注", nil) forState:UIControlStateNormal];
    [cell.followButton setTitle:DBGetStringWithKeyFromTable(@"L已关注", nil) forState:UIControlStateSelected];
    cell.followButton.tag=indexPath.row;
    [cell.followButton addTarget:self action:@selector(touchFollowButton:)];
     //1为已关注  0为未关注
    NSString*isFollow=model.isFollow;
    if ([isFollow isEqualToString:@"1"]) {
        cell.followButton.selected=YES;
    }else{
         cell.followButton.selected=NO;
    }
    
    
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}




#pragma mark  -- getDatas
-(void)getFollowDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Follow];
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%ld",self.pages];
    
      NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {

            
            if (self.pages==0) {
                [self.allDatasModel removeAllObjects];
            }
            

            for (NSDictionary*dict in data[@"data"]) {
                FollowFansModel*model=[FollowFansModel yy_modelWithDictionary:dict];
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


-(void)getFansDatas{
   
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Fans];
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%ld",self.pages];
    
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {

            
            if (self.pages==0) {
                [self.allDatasModel removeAllObjects];
            }
            
          
            for (NSDictionary*dict in data[@"data"]) {
                FollowFansModel*model=[FollowFansModel yy_modelWithDictionary:dict];
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

//关注或者取消关注的接口
-(void)followOrCancelFollow:(FollowFansModel*)model{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_FOllowOrCancelFollow];
    NSString*is_like;
    //这里的数据已经实现修改好了
    if ([model.isFollow isEqualToString:@"1"]) {
        is_like=@"1";
    }else{
        is_like=@"0";
    }
    
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":model.ID,@"is_like":is_like};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"data"]];
            
        }else{
            [self.tableView.mj_header beginRefreshing];
            
        }
        
        
    }];
    
    
    
}







#pragma mark  --touch
-(void)touchFollowButton:(UIButton*)sender{
    NSInteger number=sender.tag;
    FollowFansModel*model=self.allDatasModel[number];
    
    if (sender.selected==YES) {
        //点击之后取消关注 接口
        
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction*action=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L取消关注", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //取消关注的接口
            model.isFollow=@"0";
            sender.selected=NO;
            [self followOrCancelFollow:model];
            
        }];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:action];
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
        
      
    }else{
        //点击之后   加为关注   接口
        sender.selected=YES;
        model.isFollow=@"1";
         [self followOrCancelFollow:model];
        
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
