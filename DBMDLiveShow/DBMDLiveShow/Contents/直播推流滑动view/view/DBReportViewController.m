//
//  DBReportViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBReportViewController.h"

@interface DBReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,assign)NSInteger seletedIndex;
@property(nonatomic,strong)NSMutableArray*locatedDatas;
@end

#define Cell0  @"cell0"

@implementation DBReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L举报", nil);
    [self getLocatedDatas];
    
    [self.view addSubview:self.tableView];
   
    
}




#pragma mark-- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locatedDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:Cell0];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell0];
    }
    NSDictionary*dict=self.locatedDatas[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text=dict[@"title"];
    
    if (indexPath.row==_seletedIndex) {
        cell.imageView.image=[UIImage imageNamed:@"选中"];
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.seletedIndex=indexPath.row;
    [self.tableView reloadData];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    BGView.backgroundColor=[UIColor clearColor];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, KScreenWidth/2+50, 15)];
    label.font=[UIFont systemFontOfSize:14];
    label.text=DBGetStringWithKeyFromTable(@"L选择举报原因", nil);
    [BGView addSubview:label];
    
    return BGView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 75)];
    BGView.userInteractionEnabled=YES;
    BGView.backgroundColor=[UIColor clearColor];
    
    UIButton*sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame=CGRectMake(15, 30, KScreenWidth-30, 45);
    sureButton.userInteractionEnabled=YES;
    [sureButton setTitle:DBGetStringWithKeyFromTable(@"L确认举报", nil)];
    [sureButton setTitle:DBGetStringWithKeyFromTable(@"L请先选择举报类型", nil) forState:UIControlStateDisabled];
    sureButton.backgroundColor=KNaviColor;
    sureButton.titleColor=[UIColor whiteColor];
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:sureButton];
    
    if (self.seletedIndex<0) {
        [sureButton setEnabled:NO];
    }else{
         [sureButton setEnabled:YES];
    }
    
    return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 75;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



#pragma mark  --touch
-(void)clickSureButton{

    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Report];
    NSString*type=[NSString stringWithFormat:@"%lu",self.seletedIndex+1];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":self.mainModel.ID,@"type":type};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"data"]];
            //成功后 返回
            [self.navigationController popViewControllerAnimated:YES];
  
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

#pragma mark -- Datas
-(void)getLocatedDatas{
    self.seletedIndex=-1000;
    
    NSDictionary*dict0=@{@"image":@"未选中",@"title":DBGetStringWithKeyFromTable(@"L色情暴力", nil)};
    NSDictionary*dict1=@{@"image":@"未选中",@"title":DBGetStringWithKeyFromTable(@"L政治敏感", nil)};
    NSDictionary*dict2=@{@"image":@"未选中",@"title":DBGetStringWithKeyFromTable(@"L侵犯版权", nil)};
    NSDictionary*dict3=@{@"image":@"未选中",@"title":DBGetStringWithKeyFromTable(@"L广告传销", nil)};
    NSDictionary*dict4=@{@"image":@"未选中",@"title":DBGetStringWithKeyFromTable(@"L其他", nil)};
    
    self.locatedDatas=[@[dict0,dict1,dict2,dict3,dict4] mutableCopy];
}

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


@end
