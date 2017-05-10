//
//  PersonInfoViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/18.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "PersonInfoViewController.h"

#import "PickerChoiceView.h"   //选择器


#import "SetNameViewController.h" //修改名字
#import "SetSignViewController.h"  //修改个性签名


@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)NSInteger selectedCellIndex;   //选择的哪个cell
@property(nonatomic,strong)NSArray*dataSourceArray;   //这个是本地的数据
//@property(nonatomic,strong)NSArray*currentPersonInfo;  //当前的个人信息
@property(nonatomic,strong)NewPersonInfoModel*personModel;  //个人的信息

@end

@implementation PersonInfoViewController

-(instancetype)initWithDatas:(NewPersonInfoModel*)model{
    self=[super init];
    if (self) {
        self.personModel=model;
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L个人资料", nil);
    [self.view addSubview:self.tableView];
    
    [self makeDataSource];
   
}








#pragma mark  -- datas
-(void)makeDataSource{
    self.dataSourceArray=@[@[DBGetStringWithKeyFromTable(@"L头像", nil)],@[DBGetStringWithKeyFromTable(@"L昵称", nil),DBGetStringWithKeyFromTable(@"L性别", nil),DBGetStringWithKeyFromTable(@"L年龄", nil),DBGetStringWithKeyFromTable(@"L个性签名", nil),DBGetStringWithKeyFromTable(@"L手机号", nil)]];
}




#pragma mark  --UI
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
    cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.text=self.dataSourceArray[indexPath.section][indexPath.row];

    
    if (indexPath.section==0&&indexPath.row==0) {
        cell.detailTextLabel.text=@"";
         cell.accessoryType=UITableViewCellAccessoryNone;
        UIImageView*imageView=[cell viewWithTag:111];
        if (!imageView) {
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-15-40, 0, 40, 40)];
            imageView.tag=111;
            [imageView setCenterY:35];
  
            imageView.layer.cornerRadius=20;
            imageView.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageView];
            
            
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.personModel.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
    }else if (indexPath.section==1&&indexPath.row==0){
        cell.detailTextLabel.text=self.personModel.nick;
        
    }else if (indexPath.section==1&&indexPath.row==1){
        if ([self.personModel.gender isEqualToString:@"m"]) {
             cell.detailTextLabel.text=DBGetStringWithKeyFromTable(@"L男", nil);
        }else{
            cell.detailTextLabel.text=DBGetStringWithKeyFromTable(@"L女", nil);
        }
       
    }else if (indexPath.section==1&&indexPath.row==2){
        cell.detailTextLabel.text=self.personModel.age;
    }else if (indexPath.section==1&&indexPath.row==3){
        cell.detailTextLabel.text=self.personModel.signature;
    }else if (indexPath.section==1&&indexPath.row==4){
        cell.detailTextLabel.text=self.personModel.phoneNumber;
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        //选择的是 哪一行
        _selectedCellIndex=indexPath.row;
    }
    
    
    
    if (indexPath.section==0&&indexPath.row==0) {
        //拍照
        [self TouchAddImage];
        
    }else if (indexPath.section==1&&indexPath.row==0){
             
                
                //昵称
        SetNameViewController*vc=[[SetNameViewController alloc]initWithNibName:@"SetNameViewController" bundle:nil];
        vc.textFieldString=self.personModel.nick;
        vc.typee=TypeNameOrNumberName;
        
                [self.navigationController pushViewController:vc animated:YES];
                vc.saveBlock=^(NSString*str){
                            MyLog(@"11");
                    self.personModel.nick=str;
                            //修改的接口
                    [self changePersonInfo];

                    
                };
                
                
        
    }else if (indexPath.section==1&&indexPath.row==1){
        //性别
                PickerChoiceView*pickVC=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
                pickVC.delegate=self;
                pickVC.arrayType=GenderArray;
//        if ([self.personModel.gender isEqualToString:@"m"]) {
//              pickVC.selectStr=@"男";
//        }else{
//             pickVC.selectStr=@"女";
//        }
        
        
                [self.view addSubview:pickVC];
                
        
    }else if (indexPath.section==1&&indexPath.row==2){
        //年龄
                PickerChoiceView*pickVC=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
                pickVC.delegate=self;
                pickVC.arrayType=DeteArray;
//                pickVC.selectStr=@"18";
                [self.view addSubview:pickVC];
                
                
        
    }else if (indexPath.section==1&&indexPath.row==3){
        //个性签名
        SetSignViewController*vc=[[SetSignViewController alloc]initWithNibName:@"SetSignViewController" bundle:nil];
        vc.dataStr=self.personModel.signature;
        [self.navigationController pushViewController:vc animated:YES];
                vc.saveBlock=^(NSString*str){

                    self.personModel.signature=str;
                    //修改的接口
                    [self changePersonInfo];

                    
                };
                
                
    }else if (indexPath.section==1&&indexPath.row==4){
        //修改手机号
        //昵称
        SetNameViewController*vc=[[SetNameViewController alloc]initWithNibName:@"SetNameViewController" bundle:nil];
        vc.typee=TypeNameOrNumberNumber;
        vc.textFieldString=self.personModel.phoneNumber;
        
        [self.navigationController pushViewController:vc animated:YES];
        vc.saveBlock=^(NSString*str){
            MyLog(@"11");
            self.personModel.phoneNumber=str;
            //修改的接口
            [self changePersonInfo];
            
            
        };
        

        
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
    }
    
    return 44;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark  -- jiekou
//上传头像接口
-(void)PostImageJiekouWithData:(NSData*)data{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PostImage];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            NSString*photoUrlStr=data[@"data"];
            self.personModel.portrait=photoUrlStr;
            //更改个人资料
            [self changePersonInfo];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
}

//更改个人资料接口
-(void)changePersonInfo{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ChangePersonInfo];
    NSDictionary*dict=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    NSMutableDictionary*params=[[NSMutableDictionary alloc]initWithDictionary:dict];
    if (self.personModel.portrait!=nil) {
        [params setObject:self.personModel.portrait forKey:@"header_img"];
    }
   if (self.personModel.nick!=nil){
         [params setObject:self.personModel.nick forKey:@"nickname"];
   }
    if (self.personModel.gender!=nil){
         [params setObject:self.personModel.gender forKey:@"gender"];
    }
   if (self.personModel.age!=nil){
        [params setObject:self.personModel.age forKey:@"age"];
   }
    if (self.personModel.signature!=nil){
         [params setObject:self.personModel.signature forKey:@"mark"];
    }
    
    if (self.personModel.phoneNumber!=nil&&![self.personModel.phoneNumber isEqualToString:@""]&&![self.personModel.phoneNumber isEqualToString:[UserSession instance].user_info.phoneNumber]) {
        [params setObject:self.personModel.phoneNumber forKey:@"mobile"];
        
    }
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
              [self.tableView reloadData];
        }else{
              //重新请求接口 重新赋值
            [JRToast showWithText:data[@"errorMessage"]];
            [self.navigationController popViewControllerAnimated:YES];
          
            
        }
        
      
        
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- 相机的回调
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    定义一个newPhoto，用来存放我们选择的图片。
        UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];

        UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImageView*imageView=[cell viewWithTag:111];
        imageView.image=newPhoto;
    
            //吊接口  照片
//    NSData *data = UIImageJPEGRepresentation(newPhoto,1.0);
    NSData*data=UIImagePNGRepresentation(newPhoto);
    [self PostImageJiekouWithData:data];
    
    
    
        [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  -- delegate
- (void)PickerSelectorIndixString:(NSString *)str{
            MyLog(@"%@",str);
            
            if (self.selectedCellIndex==1) {
                        //性别
                if ([str isEqualToString:@"男"]) {
                    self.personModel.gender=@"m";
                }else{
                    self.personModel.gender=@"fm";
                }
                
                [self changePersonInfo];
                
            }else if (self.selectedCellIndex==2){
                        //年龄
                        NSDate*currentTime=[NSDate date];
                        NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString*dateString=[dateFormatter stringFromDate:currentTime];
                        NSString*currentYear=[dateString substringToIndex:4];
                        CGFloat currentFloat=[currentYear floatValue];
                        
                        NSString*getStr=[str substringToIndex:4];
                        CGFloat getFloat=[getStr floatValue];
                        
                        CGFloat aa=currentFloat-getFloat;
                        if (aa>0) {
                                    //年龄计算
                            self.personModel.age=[NSString stringWithFormat:@"%.0f",aa];
                            [self changePersonInfo];
                            
                            
                        }else{
                                    //乱填的年龄
                            [JRToast showWithText:DBGetStringWithKeyFromTable(@"L选择错误", nil)];
                            return;
                        }
                        
                        
            }
            
            
            
            
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


@end
