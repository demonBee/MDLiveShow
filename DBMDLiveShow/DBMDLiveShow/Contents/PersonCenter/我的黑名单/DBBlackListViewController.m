//
//  DBBlackListViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/7/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBBlackListViewController.h"
#import "DBFansTableViewCell.h"
#import "NewPersonInfoModel.h"

#define CELL0  @"DBFansTableViewCell"

@interface DBBlackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*allDatasModel;  //所有数据

@end

@implementation DBBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的黑名单";
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
  
    //获取黑名单列表
    [self getBlackList];
    
    
    
   
    

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
    NewPersonInfoModel*model=self.allDatasModel[indexPath.row];

    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    cell.NameLabel.text=model.nick;
    cell.FansLabel.hidden=YES;
    cell.followButton.hidden=YES;
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      NewPersonInfoModel*model=self.allDatasModel[indexPath.row];
    NSString*user_id=model.ID;
    if (!user_id) {
        [JRToast showWithText:@"该用户不存在"];
        return;
    }
    [self removeBlackListWithStr:user_id andIndex:indexPath];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}




#pragma mark  --datas
-(void)getBlackList{
    DBSelf(weakSelf);
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_RY_blackList];
    NSDictionary*headerDic=[HttpObject getRYRequestHeader];
    //
    NSDictionary*params=@{@"userId":[UserSession instance].user_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataAndRequestHeaderNoHudWithUrl:urlStr parameters:params andRequestHeader:headerDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if ([data[@"code"] integerValue]==200) {
            NSArray*array=data[@"users"];
            NSString*userStr=[array componentsJoinedByString:@","];
            
            if (userStr) {
                //获取到所有黑名单人的信息
                [weakSelf getUserInfoWithblackStr:userStr];
                
                
            }
            
            
        }else{
            [JRToast showWithText:@"获取列表失败"];
        }
        
        
        
        
        
    }];

    
    
}

//移除黑名单
-(void)removeBlackListWithStr:(NSString*)userid andIndex:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_RY_removeBlack];
    NSDictionary*headerDic=[HttpObject getRYRequestHeader];
    //
    NSDictionary*params=@{@"userId":[UserSession instance].user_id,@"blackUserId":userid};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataAndRequestHeaderNoHudWithUrl:urlStr parameters:params andRequestHeader:headerDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.allDatasModel removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            [JRToast showWithText:@"黑名单移除成功"];
            
        }else{
            [JRToast showWithText:@"移除黑名单失败"];
        }
        
        
        
        
        
    }];
    

    
}



//获取到所有黑名单人的信息
-(void)getUserInfoWithblackStr:(NSString*)userStr{
    DBSelf(weakSelf);
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Many_person];
    NSDictionary*params=@{@"user_id":[UserSession instance].user_id,@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"uid":userStr};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        [self.allDatasModel removeAllObjects];
        if ([data[@"errorCode"] integerValue]==0) {
            for (NSDictionary*dict in data[@"data"]) {
                NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithJSON:dict];
                [weakSelf.allDatasModel addObject:model];
                
            }
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
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
