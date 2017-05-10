//
//  MDLevelViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "MDLevelViewController.h"
#import "MDLevelModel.h"

@interface MDLevelViewController ()
@property(nonatomic,strong)MDLevelModel*mainModel;

@end

@implementation MDLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=DBGetStringWithKeyFromTable(@"L等级", nil);
    [self getDatas];
    
    self.coustmerBG.layer.cornerRadius=6;
    self.coustmerBG.layer.masksToBounds=YES;
    
    
    self.anchorBG.layer.cornerRadius=6;
    
    
}

-(void)reloadDatas{
    self.tips.text=[NSString stringWithFormat:@"%@",self.mainModel.tips];
    
    self.customerLevel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L用户等级：LV%@", nil),self.mainModel.WatcherLevel];
    self.customerAllEX.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L累计经验：%@", nil),self.mainModel.Watcher_totailMoney];
    self.toUpgrade.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L距离升级还差：%@", nil),self.mainModel.Watcher_Lackmoney];
    
    self.anchorLevel.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L主播等级：LV%@", nil),self.mainModel.LiveLevel];
    self.anchorAllEX.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L累计经验：%@", nil),self.mainModel.Live_totailMoney];
    self.anchorToUprade.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L距离升级还差：%@", nil),self.mainModel.Live_lackmoney];

    
    
}


#pragma mark  --jiekou
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Level];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        self.mainModel=[MDLevelModel yy_modelWithDictionary:data[@"data"]];
        [self reloadDatas];
        
        
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

@end
