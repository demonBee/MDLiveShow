//
//  PullStreamViewController.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/2/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "PullStreamViewController.h"
#import "NewPersonInfoModel.h"

#import "DBLiveBGViewController.h"
#import "DBUserPersonView.h"


#import "DBAllWatcherViewController.h"
#import "DBRealNameViewController.h"   //实名认证界面



@interface PullStreamViewController ()

@property(nonatomic,strong)NewPersonInfoModel *liveItem;  //自己的直播间的所有数据
@property(nonatomic,strong)NSURL*url;   //推流的地址
@property(nonatomic,strong)NSString*is_real;  ////0没有实名认证   1申请中   2通过实名认证   3拒绝  4禁播
@property(nonatomic,strong)NSString*tips;   //提示语



//开始推流的时候 这个view remove掉
@property(nonatomic,strong)UIView*startView;
@property(nonatomic,strong)UIButton*pullStreamButton;
@property(nonatomic,strong)UITextField*roomTextField;
@property(nonatomic,strong)UITextField*cityTextField;
@property(nonatomic,strong)UISwitch*recordSwitch;

@property(nonatomic,strong)DBLiveBGViewController*BGVC;   //可滑动view
@property(nonatomic,strong)DBUserPersonView*userPersonView;  //用户个人中心view






@end

@implementation PullStreamViewController{
  
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPullView];

    //没有开播之前上面的view
    [self makeNoliveView];
    
    
    //得到推流地址
    [self getPullStreamAddress];
    //得到该主播的所有信息
    [self getMyRoomInfoDatas];

    //观察者 用于跳弹窗
    [self addObserve];
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.userPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.offset(302);
        make.height.offset(410);
    }];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
    
}

#pragma mark  --UI



-(void)makeNoliveView{
   
    UIView*startView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    startView.backgroundColor=[UIColor clearColor];
    [self.session.previewView addSubview:startView];
    self.startView=startView;
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-40-10, 25, 40, 40)];
    [button setImage:[UIImage imageNamed:@"title_button_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchPop)];
    [startView addSubview:button];
    
    
    UITextField*roomName=[[UITextField alloc]initWithFrame:CGRectMake(60, 100, KScreenWidth-120, 40)];
    roomName.borderStyle=UITextBorderStyleRoundedRect;
    roomName.placeholder=DBGetStringWithKeyFromTable(@"L请输入房间名", nil);
    [startView addSubview:roomName];
    self.roomTextField=roomName;
    
    UITextField*cityName=[[UITextField alloc]initWithFrame:CGRectMake(60, 160, KScreenWidth-120, 40)];
    cityName.borderStyle=UITextBorderStyleRoundedRect;
    cityName.placeholder=DBGetStringWithKeyFromTable(@"L请输入城市名", nil);
    [startView addSubview:cityName];
    self.cityTextField=cityName;
    
    //录像
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 220, 150, 40)];
    titleLabel.text=DBGetStringWithKeyFromTable(@"L是否开启录播功能", nil);
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.textColor=[UIColor whiteColor];
    [startView addSubview:titleLabel];
    
    self.recordSwitch=[[UISwitch alloc]init];
    self.recordSwitch.frame=CGRectMake(KScreenWidth-60-70, 220, 70, 40);
    self.recordSwitch.thumbTintColor=[UIColor whiteColor];
    [self.recordSwitch setOn:YES];
    [startView addSubview:self.recordSwitch];
    
    
    UIButton*pullButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2-100, KScreenHeight/2-20, 200, 40)];
    pullButton.backgroundColor=KNaviColor;
    [pullButton setTitleColor:[UIColor whiteColor]];
    [pullButton setTitle:DBGetStringWithKeyFromTable(@"L开始直播", nil) forState:UIControlStateNormal];
    [pullButton addTarget:self action:@selector(touchPull)];
    [startView addSubview:pullButton];
    self.pullStreamButton=pullButton;
    
}






#pragma mark  --touch
-(void)touchPop{
    
      [self dismissViewControllerAnimated:YES completion:nil];
}





//推流
-(void)touchPull{
    //判断没数据的时候
    if (!self.liveItem) {
        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L网络延迟，请稍等", nil)];
        return;
    }else if (!_url){
        [[[UIAlertView alloc] initWithTitle:DBGetStringWithKeyFromTable(@"L错误", nil) message:DBGetStringWithKeyFromTable(@"L还没有获取到 streamURL 不能推流哦", nil) delegate:nil cancelButtonTitle:DBGetStringWithKeyFromTable(@"L知道啦", nil) otherButtonTitles:nil] show];
        return;
    }


   
    
    if ([self.is_real isEqualToString:@"0"]) {
        // 有实名认证和有直播
        [self alertVCWithLiveShow:YES andRealName:YES];
        
        
        
    }else if ([self.is_real isEqualToString:@"1"]||[self.is_real isEqualToString:@"2"]){
        //没有实名认证只有直播
         [self alertVCWithLiveShow:YES andRealName:NO];
        
    }else if ([self.is_real isEqualToString:@"3"]){
        //只有实名认证 没有直播
        [self alertVCWithLiveShow:NO andRealName:YES];
        
    }else{
        //实名认证和直播都没有
        
          [self alertVCWithLiveShow:NO andRealName:NO];
    }

}

#pragma mark  --警告框
-(void)alertVCWithLiveShow:(BOOL)canLive andRealName:(BOOL)ToWriteRealName{
    DBSelf(weakSelf);
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:DBGetStringWithKeyFromTable(@"L开始直播", nil) message:self.tips preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction*LiveshowAction=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L去直播", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf clickPullStream];
    }];
    UIAlertAction*WriteRealNameAction=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L去认证", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DBRealNameViewController*vc=[[DBRealNameViewController alloc]initWithNibName:@"DBRealNameViewController" bundle:nil];
        vc.popUpdateBlock=^(){
            [weakSelf getPullStreamAddress];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //4种可能性
    if (canLive&&ToWriteRealName) {
        [alertVC addAction:LiveshowAction];
        [alertVC addAction:WriteRealNameAction];
         [alertVC addAction:cancelAction];
        
    }else if (canLive&&!ToWriteRealName){
        [alertVC addAction:LiveshowAction];
         [alertVC addAction:cancelAction];
        
    }else if (!canLive&&ToWriteRealName){
        [alertVC addAction:WriteRealNameAction];
         [alertVC addAction:cancelAction];
        
    }else if (!canLive&&!ToWriteRealName){
        [alertVC addAction:cancelAction];
    }
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}



#pragma mark  -- 关于七牛云
-(void)addPullView{
    
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    
    self.session=   [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration
                                                             audioCaptureConfiguration:audioCaptureConfiguration
                                                           videoStreamingConfiguration:videoStreamingConfiguration
                                                           audioStreamingConfiguration:audioStreamingConfiguration
                     
                                                                                stream:nil];
    //照相机前面  这个就没有默认值？
    [_session toggleCamera];
    
    //这是水印
    [_session setWaterMarkWithImage:[UIImage imageNamed:@"qiniu"] position:CGPointMake(100, 100)];
    
    
    //开启美颜  然后那三个都设置成 50%
    [_session setBeautifyModeOn:YES];
    //    [_session setBeautify:0.5];
    //    [_session setWhiten:0.5];
    //    [_session setRedden:0.5];
    
    
    [self.view addSubview:self.session.previewView];
    
}


-(void)clickPullStream{
    if (!_session.isStreamingRunning) {
        self.pullStreamButton.enabled=NO;
        [_session startStreamingWithPushURL:_url feedback:^(PLStreamStartStateFeedback feedback) {
            NSString *log = [NSString stringWithFormat:@"session start state %lu",(unsigned long)feedback];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", log);
              
                self.pullStreamButton.enabled=YES;
                if (PLStreamStartStateSuccess == feedback) {
                    [self startPullStream];
                } else {
                    [[[UIAlertView alloc] initWithTitle:DBGetStringWithKeyFromTable(@"L错误", nil) message:DBGetStringWithKeyFromTable(@"L推流失败了", nil) delegate:nil cancelButtonTitle:DBGetStringWithKeyFromTable(@"L知道啦", nil) otherButtonTitles:nil] show];
                }
            });
        }];
    } else {
        [_session stopStreaming];
        
    }

    
}



//推流成功开始播放
-(void)startPullStream{
    //传上去 房间名和城市
    [self DatasRoomNameAndCityName];
    //移除推流按钮和右上角的返回键
    [self.startView removeFromSuperview];
    self.startView=nil;
    
    //加上 那个滑动view
    //上面添加一个可侧滑的控制器
    self.BGVC.liveItem=self.liveItem;
    [self.view insertSubview:self.BGVC.view aboveSubview:self.session.previewView];
    [self addChildViewController:self.BGVC];

    [JRToast showWithText:DBGetStringWithKeyFromTable(@"L直播中", nil) duration:3];

    
    
}
#pragma mark - 通知相关
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kNotificationClickUser object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickRoomNumber:) name:KNotificationTwo object:nil];
    
}


- (void)clickUser:(NSNotification *)notification {
    
    if (notification.userInfo[@"info"]) {
        
        NewPersonInfoModel *userItem = notification.userInfo[@"info"];
        self.userPersonView.mainModel=userItem;
        [UIView animateWithDuration:0.25 animations:^{
            self.userPersonView.hidden = NO;
            self.userPersonView.transform = CGAffineTransformIdentity;
        }];
        
    }
    
}


-(void)clickRoomNumber:(NSNotification*)notification{
    if (notification.userInfo[@"info"]) {
        NewPersonInfoModel*userItem=notification.userInfo[@"info"];
        DBAllWatcherViewController*vc=[[DBAllWatcherViewController alloc]init];
        vc.mainModel=userItem;
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

#pragma mark  -- getDatas
-(void)getPullStreamAddress{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PullAddress];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"anchor_id":[UserSession instance].user_id,@"user_id":[UserSession instance].user_id,@"token":[UserSession instance].token};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            self.url=[NSURL URLWithString:data[@"data"][@"url"]];
            self.is_real=data[@"data"][@"is_real"];
            self.tips=data[@"data"][@"tips"];
            //给两个textField 赋值
            self.cityTextField.text=data[@"data"][@"city"];
            self.roomTextField.text=data[@"data"][@"room_name"];
 
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
}

//得到直播间的model0
-(void)getMyRoomInfoDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_TwoMainInfo];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":[UserSession instance].user_id};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            NSDictionary*anchorDic=data[@"data"][@"user_id"];  
            NewPersonInfoModel *liveItem=[NewPersonInfoModel yy_modelWithDictionary:anchorDic];
            self.liveItem=liveItem;
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];

    
}


//传房间名和城市
-(void)DatasRoomNameAndCityName{
    NSString*roomName=self.roomTextField.text;
    NSString*cityName=self.cityTextField.text;
    if (!roomName) {
        roomName=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L%@的直播间", nil),self.liveItem.nick];
    }
    if (!cityName) {
        cityName=DBGetStringWithKeyFromTable(@"LL猩球", nil);
    }
    NSString*switchOn;
    if (self.recordSwitch.isOn) {
        switchOn=@"1";
    }else{
        switchOn=@"0";
    }
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RoomNameCity];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"anchor_id":[UserSession instance].user_id,@"city":cityName,@"room_name":roomName,@"is_video":switchOn};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            self.liveItem.room_name=roomName;
            self.liveItem.city=cityName;
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
}


#pragma mark  --set
-(DBLiveBGViewController *)BGVC{
    if (!_BGVC) {
        _BGVC=[[DBLiveBGViewController alloc]initWithDatas:nil andliveType:LiveRoomTypeShow andSuperVC:self];
        _BGVC.view.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
    }
    return _BGVC;
}


-(DBUserPersonView *)userPersonView{
    if (!_userPersonView) {
        _userPersonView=[DBUserPersonView creatDBUserPersonView];
        _userPersonView.hidden=YES;
        _userPersonView.transform=CGAffineTransformMakeScale(0.01, 0.01);
        [self.view addSubview:_userPersonView];
        DBSelf(weakSelf);
        [_userPersonView setCloseViewBlock:^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.userPersonView.hidden = YES;
                weakSelf.userPersonView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:nil];
        }];
        
        
        
    }
    return _userPersonView;
    
}



#pragma mark  隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end
