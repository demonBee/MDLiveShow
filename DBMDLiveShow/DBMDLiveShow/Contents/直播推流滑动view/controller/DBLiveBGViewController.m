//
//  DBLiveBGViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/13.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBLiveBGViewController.h"
#import "DBBaseViewController.h"


#import "DBLivingRoomTopView.h"
#import "TJPLivingRoomBottomView.h"
#import "RCDLive.h" //聊天室
#import "RCDLiveChatRoomViewController.h"

#import "GiveGiftView.h"
#import "taskView.h"

#pragma 推流特有的东西
#import "PullStreamViewController.h"   //推流控制器
#import "SetPushView.h"
#import "DBSliderView.h"
#import "SetBeautyView.h"
#import "ShowLiveResultView.h"



@interface DBLiveBGViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView*mainScrollView;
@property(nonatomic,strong)UIView*mainView;   //所有东西都加载 这个 view上

///** 粒子动画*/
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/**顶部的view**/
@property(nonatomic,weak)DBLivingRoomTopView *topView;
/** 底部view*/
@property(nonatomic, weak) TJPLivingRoomBottomView *bottomView;
/*聊天室VC */
@property(nonatomic,weak)RCDLiveChatRoomViewController*chatVC;
@property(nonatomic,strong) GiveGiftView*giftView;  //礼物界面
@property(nonatomic,strong)taskView*taskview;   //任务界面
#pragma 推流特有的东西
@property(nonatomic,strong)SetPushView*functionChooseView;  //功能设置界面
@property(nonatomic,strong)DBSliderView*sliderBG;   //滑动的镜头
@property(nonatomic,strong)SetBeautyView*beautyView; //美颜的view

@end

@implementation DBLiveBGViewController


-(instancetype)initWithDatas:(NewPersonInfoModel*)liveItem andliveType:(LiveRoomType)liveType andSuperVC:(UIViewController*)superVC{
   self= [super init];
    if (self) {
        _liveItem=liveItem;
        _liveType=liveType;
        self.superVC=superVC;
        
    }
    return self;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainScrollView addSubview:self.mainView];
    self.mainScrollView.delegate=self;
        
    
    
    //设置底部的按钮
    [self bottomView];
    //顶部
    [self topView];
    //延迟个3秒 加上个粒子动画
    [self performSelector:@selector(showEmitterLayer) withObject:nil afterDelay:3.0];
    
}


-(void)dealloc{
    //移除粒子动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
    
    
    [self.topView.timer invalidate];
    self.topView.timer=nil;

}





-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.topView.frame = CGRectMake(0, 20, KScreenWidth, 80);
    self.bottomView.frame = CGRectMake(0, KScreenHeight - 54, KScreenWidth, 44);
   
}


#pragma mark  -- touch
-(void)showEmitterLayer{
    //粒子动画开始
    [self.emitterLayer setHidden:NO];
    
}

#pragma mark  -- delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
    self.chatVC.inputBar.hidden=YES;
    
    
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

#pragma mark  -- datas
#pragma mark  -- 接口
//这里可以调用进入直播间的接口
-(void)intoShowRoom{
    DBSelf(weakSelf);
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_intoRoom];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":self.liveItem.ID};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            
            
        }else{
//            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        //进入直播间之后显示  topView
        //不管是不是成功  都要吊用
        weakSelf.topView.mainModel=weakSelf.liveItem;
        
    }];
    
    
    
}


//离开直播间
-(void)leaveShowRoomData{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_leaveRoom];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":self.liveItem.ID};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        
    }];
    
    
}


//获取聊天室token
-(void)aboutChatRoom{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ProductChatRoomToken];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
 
            NSString *token = data[@"data"];
#pragma 成功了
            [[RCDLive sharedRCDLive] connectRongCloudWithToken:token success:^(NSString *loginUserId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RCUserInfo *user = [[RCUserInfo alloc]init];
                    user.userId = [UserSession instance].user_id;
                    user.portraitUri = [UserSession instance].user_info.portrait;
                    user.name = [UserSession instance].user_info.nick;
                    
                    [RCIMClient sharedRCIMClient].currentUserInfo = user;
                    RCDLiveChatRoomViewController *chatRoomVC = [[RCDLiveChatRoomViewController alloc]init];
                    weakSelf.chatVC=chatRoomVC;
                    chatRoomVC.conversationType = ConversationType_CHATROOM;
                    chatRoomVC.targetId = weakSelf.liveItem.ID;   //主播的聊天id
//                    chatRoomVC.isScreenVertical = YES;
                    chatRoomVC.view.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                    [weakSelf.mainView insertSubview:chatRoomVC.view atIndex:0];
                    [weakSelf addChildViewController:chatRoomVC];
            

                });
            } error:^(RCConnectErrorCode status) {
              
                MyLog(@"%ld",(long)status);
                
                
            } tokenIncorrect:^{
                MyLog(@"错误");
            
            }];
            
          
        }else{
            [JRToast showWithText:DBGetStringWithKeyFromTable(@"L获取聊天室失败", nil)];
        }
      
        
    }];
    
    
}


#pragma mark -- set
- (CAEmitterLayer *)emitterLayer {
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        //发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(KScreenWidth - 50, KScreenHeight - 50);
        //发射器尺寸
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        //渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;

        NSMutableArray <CAEmitterCell *>*emitterCellArr = [NSMutableArray array];
        //创建粒子
        for (int i = 0; i < 10; i++) {
            //发射单元
            CAEmitterCell *cell = [CAEmitterCell emitterCell];
            //粒子速率 默认1/s
            cell.birthRate = 1;
            //粒子存活时间
            cell.lifetime = arc4random_uniform(4) + 1;
            //粒子生存时间容差
            cell.lifetimeRange = 1.5;
            //粒子显示内容
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            cell.contents = (__bridge id _Nullable)(([image CGImage]));
            //粒子运动速度
            cell.velocity = arc4random_uniform(100) + 100;
            //粒子运动速度容差
            cell.velocityRange = 80;
            //粒子在xy平面的发射角度
            cell.emissionLongitude = M_PI + M_PI_2;
            //发射角度容差
            cell.emissionRange = M_PI_2 / 6;
            //缩放比例
            cell.scale = 0.3;
            [emitterCellArr addObject:cell];
        }

        emitterLayer.emitterCells = emitterCellArr;
        [_mainView.layer addSublayer:emitterLayer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}





//赋值
-(void)setLiveItem:(NewPersonInfoModel *)liveItem{
    _liveItem = liveItem;
    
    //加上一个聊天室
    [self aboutChatRoom];

    //进入直播间
    [self intoShowRoom];

    
}




-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _mainScrollView.contentSize=CGSizeMake(2*[UIScreen mainScreen].bounds.size.width, 0);
        _mainScrollView.backgroundColor=[UIColor clearColor];
        _mainScrollView.pagingEnabled=YES;
        _mainScrollView.showsHorizontalScrollIndicator=NO;
        _mainScrollView.bounces=NO;
        self.edgesForExtendedLayout=NO;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//        _mainView.backgroundColor=[UIColor greenColor];
    }
    return _mainView;
}





- (DBLivingRoomTopView *)topView {
    if (!_topView) {
        DBLivingRoomTopView *topView = [[DBLivingRoomTopView alloc] initWithFrame:CGRectZero];
        topView.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:topView];
        _topView = topView;
    }
    return _topView;
}

- (TJPLivingRoomBottomView *)bottomView {
    if (!_bottomView) {
        TJPLivingRoomBottomView *bottomView = [TJPLivingRoomBottomView bottomView];
        bottomView.liveType=self.liveType;
        bottomView.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:bottomView];
        _bottomView = bottomView;
        
        __weak typeof (self)weakSelf=self;
        [_bottomView setButtonClickedBlock:^(LivingRoomBottomViewButtonClickType clickType, UIButton *button) {
            switch (clickType) {
                case LivingRoomBottomViewButtonClickTypeChat:
                {
                    [weakSelf.chatVC showInputBar:nil];
                    MyLog(@"chat");
                }
                    break;
                    #pragma 推流端 特有的 不用加判断
                case LivingRoomBottomViewButtonClickTypeSet:
                {
                     [weakSelf.functionChooseView show];
                    MyLog(@"展示设置功能");
                }
                    break;

                    
                case LivingRoomBottomViewButtonClickTypeGift:
                {
                    MyLog(@"礼物");
                    [weakSelf.giftView show];
                    
                    
                }
                    break;
                case LivingRoomBottomViewButtonClickTypeWork:
                {
                    MyLog(@"任务");
                    [weakSelf.taskview show];
                    
                }
                    break;
                case LivingRoomBottomViewButtonClickTypeShare:
                {
                    
                    [[DBBaseViewController sharedManager] showShareMenuWithAnchor_id:weakSelf.liveItem.ID];
                    MyLog(@"share");
                    
                }
                    break;
                    #pragma 推流端 特有的
                case LivingRoomBottomViewButtonClickTypeBack:
                {
                    MyLog(@"关闭");
                    if (weakSelf.liveType==LiveRoomTypeWatch) {
                        [weakSelf watchLiveCancel];
                       
                    }else{
                        [weakSelf pullStreamCancel];
                       
                        
                    }
                   
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
        }];

        
        
    }
    return _bottomView;
    
}
#pragma mark  -- 两个退出直播间的方法
//观看直播 退出时候
-(void)watchLiveCancel{
    [self leaveShowRoomData];
    
     [self.navigationController popViewControllerAnimated:YES];
}

//推流 退出时候
-(void)pullStreamCancel{
    DBSelf(weakSelf)
     PullStreamViewController*supervc= (PullStreamViewController*)self.superVC;
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:DBGetStringWithKeyFromTable(@"L关闭直播", nil) message:DBGetStringWithKeyFromTable(@"L确定要关闭直播？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //停止推流
        [supervc.session stopStreaming];
        //离开
        [weakSelf leaveShowRoomData];


        
        //显示view
        ShowLiveResultView*resultView=[ShowLiveResultView creatResultViewWith:_liveItem];
        [self.view addSubview:resultView];
        
               
        
    }];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:DBGetStringWithKeyFromTable(@"L取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:sure];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];

    
    
    
    
   
}




-(GiveGiftView *)giftView{
    if (!_giftView) {
        _giftView=[[GiveGiftView alloc]initWithGiveAnthorID:self.liveItem.ID andmainViewFrame:CGRectZero andSuperView:self.mainView];
    }
    return _giftView;
}

-(taskView *)taskview{
    if (!_taskview) {
        _taskview=[[taskView alloc]initWithGiveAnthorID:self.liveItem.ID andmainViewFrame:CGRectZero andSuperView:self.mainView];
    }
    return _taskview;
}


#pragma mark --  推流端 特有的
-(SetPushView *)functionChooseView{
    if (!_functionChooseView) {
        _functionChooseView=[[SetPushView alloc]initWithmMainViewFrame:CGRectZero andSuperView:self.view];
       PullStreamViewController*supervc= (PullStreamViewController*)self.superVC;
        
        __weak typeof(self)welkSelf=self;
        _functionChooseView.clickFundationBlock=^(NSInteger number){
            switch (number) {
                case 0:{
                    //静音
                    if (supervc.session.muted) {
                         supervc.session.muted=!supervc.session.muted;
                        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L已开启静音", nil)];
                    }else{
                        supervc.session.muted=!supervc.session.muted;
                        [JRToast showWithText:DBGetStringWithKeyFromTable(@"L已关闭静音", nil)];

                    }
                    
                   
                    
                    break;}
                case 1:{
                    //翻转镜头
                    //照相机前面

                    [supervc.session toggleCamera];
                    
                    break;}
                    
                case 2:{
                    //镜头缩放
                    [welkSelf.sliderBG show];
                    
                    break;}
                    
                case 3:{
                    //美颜
                    [welkSelf.beautyView show];
                    break;}
                    
                    
                default:
                    break;
            }
            
            
        };
        
        [self.view addSubview:_functionChooseView];
    }
    
    return _functionChooseView;
}


-(DBSliderView *)sliderBG{
     PullStreamViewController*supervc= (PullStreamViewController*)self.superVC;
//    DBSelf(weakSelf)
    if (!_sliderBG) {
        _sliderBG=[[DBSliderView alloc]initWithType:sliderTypePhoto andsuperView:self.view andMaxValue:supervc.session.videoActiveFormat.videoMaxZoomFactor];
        _sliderBG.slideBlock=^(UISlider*slider){
            supervc.session.videoZoomFactor = slider.value;
            
        };
        
    }
    return _sliderBG;
}





-(SetBeautyView *)beautyView{
    DBSelf(weakSelf)
    PullStreamViewController*supervc= (PullStreamViewController*)self.superVC;

    if (!_beautyView) {
        _beautyView=[SetBeautyView creatBeautyViewWithSuperView:self.view];
               
        //这里就需要各个点击事件的block了
        _beautyView.switchBlock=^(BOOL isOn){
            //开启美颜
            [supervc.session setBeautifyModeOn:isOn];

            
        };
        
        
        _beautyView.FirstSliderBlock=^(CGFloat value){
            [supervc.session setBeautify:value];
            
        };
        
        _beautyView.SecondSliderBlock=^(CGFloat value){
            [supervc.session setWhiten:value];
            
        };
        
        _beautyView.ThirdSliderBlock=^(CGFloat value){
            [supervc.session setRedden:value];
            
        };
        
        
    }
    return _beautyView;
}




#pragma mark  -- function
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
