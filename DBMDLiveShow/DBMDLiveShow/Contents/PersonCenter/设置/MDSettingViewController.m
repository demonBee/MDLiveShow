//
//  MDSettingViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/18.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDSettingViewController.h"

#import "AboutOurViewController.h"     //关于我们
#import "PersonInfoViewController.h"
#import "XLTabBarViewController.h"

@interface MDSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*dataSourceArray;
@end

@implementation MDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L设置", nil);
    [self.view addSubview:self.tableView];


    [self setDataSource];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array=self.dataSourceArray[section];
    return array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.dataSourceArray[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];

    cell.detailTextLabel.text=self.dataSourceArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:12];

    
    if (indexPath.section==0&&indexPath.row==0) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.detailTextLabel.text=self.personModel.ID;
        
        
    }else if (indexPath.section==0&&indexPath.row==1){
         cell.detailTextLabel.text=@"";
        
    }else if (indexPath.section==1&&indexPath.row==0){
        cell.accessoryType=UITableViewCellAccessoryNone;
        //计算出缓存量
       CGFloat size= [DBTools folderSize];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fMB",size];
        
    }else if (indexPath.section==1&&indexPath.row==1){
           cell.detailTextLabel.text=@"";
        
    }else if (indexPath.section==1&&indexPath.row==2){
         cell.accessoryType=UITableViewCellAccessoryNone;
        
        //当前语言
        NSString*language=[DBLanguageTool userLanguage];
        NSString*currentLanguage;
       
        if([language isEqualToString:@"en"]){//判断当前的语言，进行改变
            currentLanguage=DBGetStringWithKeyFromTable(@"L英文", nil);
            
        }else{
            currentLanguage=DBGetStringWithKeyFromTable(@"L中文", nil);
           
        }

         cell.detailTextLabel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L当前语言--%@", nil),currentLanguage];
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        //  无
    }else if (indexPath.section==0&&indexPath.row==1){
        //个人资料界面
        PersonInfoViewController*vc=[[PersonInfoViewController alloc]initWithDatas:self.personModel];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1&&indexPath.row==0){
        //清楚缓存
        [DBTools removeCache];
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L清理成功", nil)];
        [self.tableView reloadData];
        
    }else if (indexPath.section==1&&indexPath.row==1){
        //关于我们
        AboutOurViewController*vc=[[AboutOurViewController alloc]initWithNibName:@"AboutOurViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section==1&&indexPath.row==2){
        //切换语言
        NSString*language=[DBLanguageTool userLanguage];
        NSString*OtherLanguage;
        NSString*OtherStr;
        if([language isEqualToString:@"en"]){//判断当前的语言，进行改变
            OtherLanguage=DBGetStringWithKeyFromTable(@"L中文", nil);
            OtherStr=CNS;
        }else{
             OtherLanguage=DBGetStringWithKeyFromTable(@"L英文", nil);
             OtherStr=EN;
        }

        NSString*message=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L是否需要切换到%@", nil),OtherLanguage];
        
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:DBGetStringWithKeyFromTable(@"L切换语言", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction*sure=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [DBLanguageTool setUserlanguage:OtherStr];
            XLTabBarViewController*tabBar=[[XLTabBarViewController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController=tabBar;
            
        }];
        
        [alertVC addAction:sure];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.dataSourceArray.count-1) {
        return 60;
    }
    
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.dataSourceArray.count-1) {
        UIView*clearView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
        clearView.backgroundColor=[UIColor clearColor];
        
        UIButton*whiteButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 12, KScreenWidth, 48)];
        whiteButton.backgroundColor=[UIColor whiteColor];
        [whiteButton setTitle:DBGetStringWithKeyFromTable(@"L退出登录", nil) forState:UIControlStateNormal];
        [whiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [whiteButton addTarget:self action:@selector(touchLoginOut) forControlEvents:UIControlEventTouchUpInside];
        [clearView addSubview:whiteButton];
        
        
        return clearView;

    }
    
    return nil;
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  -- Datas
-(void)setDataSource{
    self.dataSourceArray=@[@[DBGetStringWithKeyFromTable(@"LID号", nil),DBGetStringWithKeyFromTable(@"L个人资料", nil)],@[DBGetStringWithKeyFromTable(@"L清理缓存", nil),DBGetStringWithKeyFromTable(@"L关于我们", nil),DBGetStringWithKeyFromTable(@"L切换语言", nil)]];
    
}


#pragma mark  --touch
-(void)touchLoginOut{
    MyLog(@"11");
    [UserSession cleanUser];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


@end
