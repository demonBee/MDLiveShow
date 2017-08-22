//
//  PlayViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Qiniu/QiniuSDK.h>
#import "DBChooseHotelShowView.h"

#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//static NSString *const kUploadToken = @"MqF35-H32j1PH8igh-am7aEkduP511g-5-F7j47Z:0gzBOkhm3KsFGbGk2HdKfA4jZp4=:eyJzY29wZSI6InNob3J0LXZpZGVvIiwiZGVhZGxpbmUiOjE2NTA3MTExMDcsInVwaG9zdHMiOlsiaHR0cDovL3VwLXoyLnFpbml1LmNvbSIsImh0dHA6Ly91cGxvYWQtejIucWluaXUuY29tIiwiLUggdXAtejIucWluaXUuY29tIGh0dHA6Ly8xODMuNjAuMjE0LjE5OCJdfQ==";
//static NSString *const kURLPrefix = @"http://oowtvx1xy.bkt.clouddn.com";

@interface PlayViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVAsset *movieAsset;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *processerToolboxView;

@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIProgressView *progressView;


@property(nonatomic,strong)NSString*uploadToken;
@property(nonatomic,strong)NSString*urlPrefix;


@property(nonatomic,strong)DBChooseHotelShowView*hotelShowView;
@property(nonatomic,strong)UITextField*cityTextField;
@property(nonatomic,strong)NSMutableArray*saveCityArray;
@property(nonatomic,strong)NSString*cityName;
@property(nonatomic,strong)NSString*city_id;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //得到前缀
    self.urlPrefix=@"http://meipai.zhiboquan.net";
    
    //得到token
    [self getQNToken];
    
    
    [self setupToolboxUI];
    
    [self initPlayLayer];
    
    self.playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [self.playButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.playButton belowSubview:self.baseToolboxView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    self.progressView.trackTintColor = [UIColor blackColor];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_player pause];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)initPlayLayer {
    if (!_url) {
        return;
    }
    
    self.movieAsset = [AVURLAsset URLAssetWithURL:_url options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:_movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    self.playerLayer.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    UIView *playerView = [[UIView alloc] initWithFrame:self.playerLayer.frame];
    [playerView.layer addSublayer:self.playerLayer];
    [self.view insertSubview:playerView belowSubview:self.baseToolboxView];
}

- (void)setupToolboxUI {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 64)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    //关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [self.uploadButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    self.uploadButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    self.uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.uploadButton addTarget:self action:@selector(WriteInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.uploadButton];
}

- (void)pressPlayButton:(UIButton *)button {
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)WriteInfo{
    
    //先选择城市， 后在里面确定内容上传。
    [self clickChooseCity];

    
    
}


-(void)showAlertVC{
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"上传短视频" message:@"完善短视频信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*titleTF=alertVC.textFields[0];
        UITextField*cityTF=alertVC.textFields[1];
        
        NSString*titleStr=titleTF.text;
        if (titleTF.text.length==0) {
            titleStr=@"";
        }
        
        NSString*cityStr=cityTF.text;
        if (cityTF.text.length==0) {
            cityStr=@"";
        }
        
        
        [self uploadButtonClickWithTitle:titleStr andCity:cityStr];
        
        
    }];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:sure];
    [alertVC addAction:cancel];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入视频标题";
        
    }];
    
    
    
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请选择所在城市";
        self.cityTextField=textField;
        self.cityTextField.enabled=NO;
        self.cityTextField.text=self.cityName;

        
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    

    
}


- (void)uploadButtonClickWithTitle:(NSString*)titleStr andCity:(NSString*)cityStr {
    
    if (!self.uploadToken) {
        [JRToast showWithText:@"未获取上传token,可能网速较慢"];
        return;
    }
    
    
    self.uploadButton.selected = !self.uploadButton.selected;
    if (!self.uploadButton.selected) {
        return;
    }
    
    NSString *filePath = _url.path;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *key = [NSString stringWithFormat:@"short_video_%@.mp4", [formatter stringFromDate:[NSDate date]]];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone2];
    }];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = percent;
        });
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:^BOOL{
                                                         return !self.uploadButton.isSelected;
                                                     }];
    [[QNUploadManager sharedInstanceWithConfiguration:config] putFile:filePath key:key token:_uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        self.uploadButton.selected = NO;
        self.progressView.hidden = YES;
        NSLog(@"resp = %@",resp);
        NSLog(@"info = %@",info);
        if(info.error){
            [self showAlertWithMessage:[NSString stringWithFormat:@"上传失败，error: %@", info.error]];
            return ;
        }
//        self.urlPrefix=@"http://meipai.zhiboquan.net";
        NSString *urlString = [NSString stringWithFormat:@"%@//%@", _urlPrefix, key];
        
//        [self addAlertTextFiledAndPut:urlString];
        
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = urlString;
//        [self showAlertWithMessage:[NSString stringWithFormat:@"上传成功，地址：%@ 已复制到系统剪贴板", urlString]];
        
        
        //这图片 直接动态获取
        NSString*imageStr=[NSString stringWithFormat:@"%@?vframe/jpg/offset/0",urlString];
        CGFloat Long=[DBTools durationWithVideo:self.url];
        NSString*videoLong=[NSString stringWithFormat:@"%.0f",Long];
        NSString*currentTimeStamp=[DBTools getNowTimeTimestamp];
        
        
        
        
        
        
        //先要判断 图片地址有没有  没有的话提示 稍等
        [self InputInfoWithVideoStr:urlString andTitle:titleStr andCity:cityStr andTime:currentTimeStamp andVideoLong:videoLong andVideoImage:imageStr];

        
        
        
    } option:uploadOption];
    
    
    
    
}

- (void)showAlertWithMessage:(NSString *)message {
    NSLog(@"alert message: %@", message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification {
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _playButton.alpha = 1.0f;
    }];
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _player = nil;
    _playerLayer = nil;
    _playerItem = nil;
    _movieAsset = nil;
    
    _baseToolboxView = nil;
}



#pragma mark  -- self
-(void)getQNToken{

    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_meipaiToken];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            NSString*token=data[@"data"];
            self.uploadToken=token;
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
}








-(void)InputInfoWithVideoStr:(NSString*)videoAddress andTitle:(NSString*)titleStr andCity:(NSString*)cityStr andTime:(NSString*)currentTimeStamp andVideoLong:(NSString*)videoLong andVideoImage:(NSString*)videoImage{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_giveService];
    
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"title":titleStr,@"url":videoAddress,@"snapshot_img":videoImage,@"location":cityStr,@"city_id":self.city_id,@"duration":videoLong,@"send_time":currentTimeStamp};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:@"短视频上传成功" duration:5.0 ];
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.dismissBlock) {
                    self.dismissBlock();
                }
            
            }];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        
    }];
    
    
    
    
    
}
-(DBChooseHotelShowView *)hotelShowView{
    if (!_hotelShowView) {
        _hotelShowView=[DBChooseHotelShowView chooseHotelShowView];
        [[UIApplication sharedApplication].keyWindow addSubview:_hotelShowView];
    }
    return _hotelShowView;
}

-(NSMutableArray *)saveCityArray{
    if (!_saveCityArray) {
        _saveCityArray=[NSMutableArray array];
    }
    return _saveCityArray;
}

#pragma mark  -- click
-(void)clickChooseCity{
    [self.saveCityArray removeAllObjects];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_CountryCityList];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            NSArray*array=data[@"data"];
            for (NSDictionary*dict in array) {
                chooseCityModel*model=[chooseCityModel yy_modelWithDictionary:dict];
                
                [self.saveCityArray addObject:model];
            }
            
            
            [self.hotelShowView getValue:self.saveCityArray];
            [self.hotelShowView show];
            DBSelf(weakSelf);
            self.hotelShowView.clickCityBlock = ^(chooseCityModel *mainModel) {
                        weakSelf.city_id=mainModel.city_id;
                        weakSelf.cityName=mainModel.city_name;
                //
                //        //显示下
//                        weakSelf.cityTextField.text=weakSelf.cityName;
                [weakSelf showAlertVC];
                
            };

            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];

    
    
   
    
}


//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    //写你要实现的：页面跳转的相关代码
////    [textField becomeFirstResponder];
//    if ([textField isEqual:self.cityTextField]) {
////        [textField resignFirstResponder];
////        [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
//        [self clickChooseCity];
//        
//        
//        
//         return YES;
//    }
//    return YES;
//   
//}

@end
