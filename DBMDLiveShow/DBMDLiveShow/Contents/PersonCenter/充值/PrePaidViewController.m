//
//  PrePaidViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "PrePaidViewController.h"
#import "PrePaidTableViewCell.h"




#define CELL0    @"PrePaidTableViewCell"

@interface PrePaidViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UILabel* moneyLabel;  //当前多少钱

@property(nonatomic,strong)NewPersonInfoModel*personModel;
@property(nonatomic,strong)NSArray*prepaidArray;  //充值本地数据




@end

@implementation PrePaidViewController

-(instancetype)initWithDatas:(NewPersonInfoModel*)datas{
    self=[super init];
    if (self) {
        self.personModel=datas;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L充值", nil);
    [self setArray];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    self.tableView.tableHeaderView=[self makeTopView];
}

#pragma mark  --makeUI
-(UIView*)makeTopView{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 125)];
    mainView.backgroundColor=DBColor(238, 204, 246);
    
    UIView*secondView=[[UIView alloc]initWithFrame:CGRectMake(40, 15, KScreenWidth-80, 110)];
    secondView.backgroundColor=KNaviColor;
    secondView.layer.cornerRadius=6;
    secondView.layer.masksToBounds=YES;
    [mainView addSubview:secondView];
    
    
    UILabel*showLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, KScreenWidth-100, 20)];
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.font=[UIFont systemFontOfSize:14];
    showLabel.textColor=[UIColor whiteColor];
    showLabel.text=DBGetStringWithKeyFromTable(@"L剩余珍珠", nil);
    [secondView addSubview:showLabel];
    
    UILabel*numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, KScreenWidth-100, 35)];
    numberLabel.textAlignment=NSTextAlignmentCenter;
    numberLabel.font=[UIFont systemFontOfSize:14];
    numberLabel.textColor=[UIColor whiteColor];
    numberLabel.text=@"0";
    self.moneyLabel=numberLabel;
    [secondView addSubview:numberLabel];

    
    return mainView;
}

#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.prepaidArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrePaidTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
#pragma  剩余多少钱
    self.moneyLabel.text=self.personModel.CurrencyNumber;
    
    cell.titleLabel.text=self.prepaidArray[indexPath.row][@"title"];
    [cell.moneyButton setTitle:self.prepaidArray[indexPath.row][@"money"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

 
//    父类中处理
    [self buyWithType:indexPath.row];
    
   
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    mainView.backgroundColor=[UIColor whiteColor];
    

    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, KScreenWidth/2, 20)];
    label.text=DBGetStringWithKeyFromTable(@"L选择金额充值", nil);
    label.font=[UIFont systemFontOfSize:14];
    [mainView addSubview:label];
    

    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, KScreenWidth, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [mainView addSubview:lineView];
    
    return mainView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

#pragma mark  --touch


#pragma mark  --delegate
- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    NSString *transactionReceiptString=[receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (transactionReceiptString.length<=0) {
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L支付程序错误", nil)];
        return;
    }else{
        //这里吊用接口  来验证支付成功与否  并成功之后给他充钱
        
        [self verifyMoneySuccessInterface:transactionReceiptString];
        
        
        
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


#pragma mark  --allDatas
//校验是否充值成功
-(void)verifyMoneySuccessInterface:(NSString*)receiptString{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_appPurchase];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"apple_receipt":receiptString};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //成功了  得到余额  然后刷新余额。
            [UserSession instance].user_info.CurrencyNumber=data[@"data"];
            self.personModel.CurrencyNumber=data[@"data"];
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
    
}


-(void)setArray{
    NSDictionary*dict0=@{@"title":@"6",@"money":@"6"};
    NSDictionary*dict1=@{@"title":@"30",@"money":@"30"};
    NSDictionary*dict2=@{@"title":@"50",@"money":@"50"};
    NSDictionary*dict3=@{@"title":@"98",@"money":@"98"};
    NSDictionary*dict4=@{@"title":@"388",@"money":@"388"};

    
    self.prepaidArray=@[dict0,dict1,dict2,dict3,dict4];
    
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

#pragma mark  -- set

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
