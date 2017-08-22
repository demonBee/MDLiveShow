    //
//  MoviePlayerViewController.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
//#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"

#import "UINavigationController+ZFFullscreenPopGesture.h"

@interface MoviePlayerViewController () <ZFPlayerDelegate>
/** 播放器View的父视图*/
@property (weak, nonatomic)  IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation MoviePlayerViewController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
//        self.playerView.playerPushedOrPresented = NO;
    }
    
    
    self.navigationController.navigationBarHidden=YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
//        [self.playerView pause];
//        self.playerView.playerPushedOrPresented = YES;
    }
    
    
      self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden=YES;
//    self.videoURL=[NSURL URLWithString:@"http://ojnoo5stt.bkt.clouddn.com/recordings/z1.zhibojian11.mdzb_3/1498027047_1498027091.m3u8"];
    self.zf_prefersNavigationBarHidden = YES;
    /*
    self.playerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    */
    
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

//- (BOOL)prefersStatusBarHidden {
//    return ZFPlayerShared.isStatusBarHidden;
//}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)zf_playerDownload:(NSString *)url {
//    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
//}


//分享啊
- (void)zf_playerDownload:(NSString *)url{
    MyLog(@"这里是分享");
  //得到分享的东西
     [self ToGetShareDatas];
    
    
    
    
    
}




- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
//    self.backBtn.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = 0;
    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
//    self.backBtn.hidden = fullscreen;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = !fullscreen;
    }];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    NSString*titleStr=@"";
    if (self.videoType==PlayViewTypePlayBack) {
        titleStr=self.videoModel.room_name;
    }else{
        titleStr=[NSString stringWithFormat:@"%@",self.meiPaiModel.title];
    }
    
    
    
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            =titleStr;
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
//        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
//                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;

    }
    return _playerView;
}

#pragma mark - Action

//- (IBAction)backClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (IBAction)playNewVideo:(UIButton *)sender {
//    self.playerModel.title            = @"这是新播放的视频";
//    self.playerModel.videoURL         = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
//    // 设置网络封面图
//    self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
//    // 从xx秒开始播放视频
//    // self.playerModel.seekTime         = 15;
//    [self.playerView resetToPlayNewVideo:self.playerModel];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark  --   自己的接口

-(void)ToGetShareDatas{
    NSString*jiekouType;
    NSString*video_id;
    
    if (self.videoType==PlayViewTypePlayBack) {
        //录像的分享
        //        self.videoModel;
        jiekouType=@"1";
        video_id=self.videoModel.video_id;
        
    }else if (self.videoType==PlayViewTypeMeiPai){
        //美拍的分享
        //        self.meiPaiModel;
        jiekouType=@"2";
        video_id=self.meiPaiModel.meipai_id;
    }

    
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ShareVideoAndMeiPai];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"video_id":video_id,@"type":jiekouType};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            //这里就需要分享出去了  吊分享的sdk 了
            NSString*shareUrl=data[@"data"];
            
            [self ToShareWithStr:shareUrl];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
    
}


-(void)ToShareWithStr:(NSString*)shareStr{
    //分享
    [self setUpShare];
    
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //点击了某个分享按钮之后 成功就吊用 获取分享信息的接口
        //获取了分享的信息 在
      
        NSString*webStr=shareStr;
        NSString*imageStr;
        NSString*titleStr;
        NSString*desStr;
        
        if (self.videoType==PlayViewTypePlayBack) {
            imageStr=self.videoModel.snapshot_img;
            titleStr=@"录像";
            desStr=self.videoModel.room_name;
            
        }else if (self.videoType==PlayViewTypeMeiPai){
            //美拍的分享
            imageStr=self.meiPaiModel.snapshot_img;
            titleStr=@"美拍";
            desStr=self.meiPaiModel.title;
        }

        
        
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
              UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:desStr thumImage:imageStr];
        //设置网页地址
        shareObject.webpageUrl = webStr;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        
        //我估计是图片没有的问题造成的
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
            if (error) {
                [JRToast showWithText:[NSString stringWithFormat:@"%@",error]];
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    //                UMSocialShareResponse *resp = data;
                    [JRToast showWithText:data[@"分享成功"]];
                    
                }else{
                    
                    [JRToast showWithText:[NSString stringWithFormat:@"%@",data]];
                }
            }
            
        }];
    }];
        
        
        
        
        
        
        
        
        
        
   
  
    
}



@end
