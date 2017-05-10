//
//  LivingRoomCollectionViewCell.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/2/21.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "LivingRoomCollectionViewCell.h"
#import <PLPlayerKit/PLPlayerKit.h>

#define enableBackgroundPlay    1

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface LivingRoomCollectionViewCell()<PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
/** 直播开始前的占位图片*/
@property(nonatomic, weak) UIImageView *placeHolderView;

@property (nonatomic, assign) int reconnectCount;   //重连的次数 大于3次返回
@property (nonatomic, strong) NSURL *URL;    //flv 播放

@end

@implementation LivingRoomCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
    }
     return self;
}




#pragma mark  --  七牛云的所有东西
-(void)setLiveItem:(NewPersonInfoModel *)liveItem{
    _liveItem = liveItem;
    //播放
    self.reconnectCount=0;
   
    self.URL=[NSURL URLWithString:liveItem.stream_addr];
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    self.player = [PLPlayer playerWithURL:self.URL option:option];
    self.player.delegate = self;
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.backgroundPlayEnable = enableBackgroundPlay;
#if !enableBackgroundPlay
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayer) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif
    [self setupUI];
    
    [self startPlayer];

    
}

- (void)addActivityIndicatorView {
    if (self.activityIndicatorView) {
        return;
    }
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    [self.contentView addSubview:activityIndicatorView];
    [self.contentView bringSubviewToFront:activityIndicatorView];
    [activityIndicatorView stopAnimating];
    
    self.activityIndicatorView = activityIndicatorView;
}

- (void)setupUI {
    if (self.player.status != PLPlayerStatusError) {
        // add player view
        UIView *playerView = self.player.playerView;
        if (!playerView.superview) {
            playerView.contentMode = UIViewContentModeScaleAspectFit;
            playerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleTopMargin
            | UIViewAutoresizingFlexibleLeftMargin
            | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleHeight;
            [self.contentView addSubview:playerView];
            
          
        }
    }
    
}

- (void)startPlayer {
      self.placeHolderView.hidden=NO;
    [self addActivityIndicatorView];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.player play];
}






#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (PLPlayerStatusCaching == state) {
         self.placeHolderView.hidden=NO;
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
    
    if (state==PLPlayerStatusPlaying) {
         self.placeHolderView.hidden=YES;
    }
    
    MyLog(@"%ld",(long)state);
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
     self.placeHolderView.hidden=NO;
    [self.activityIndicatorView stopAnimating];
    [self tryReconnect:error];
}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 3) {
        _reconnectCount ++;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DBGetStringWithKeyFromTable(@"L错误", nil) message:[NSString stringWithFormat:@"错误 %@，播放器将在%.1f秒后进行第 %d 次重连", error.localizedDescription,0.5 * pow(2, self.reconnectCount - 1), _reconnectCount] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
            
        });
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player play];
        });
    }else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) wself = self;
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               __strong typeof(wself) strongSelf = wself;
                                                               [strongSelf.parentVc.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:@(YES) waitUntilDone:NO];
                                                           }];
            [alert addAction:cancel];
            [self.parentVc presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        NSLog(@"%@", error);
    }
}


#pragma mark  --set
- (UIImageView *)placeHolderView {
    if (!_placeHolderView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.frame=[UIScreen mainScreen].bounds;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.liveItem.portrait] placeholderImage:[UIImage imageNamed:@"placeholder_750x1334"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
        }];
        
        [self.contentView addSubview:imageView];
        _placeHolderView = imageView;
        _placeHolderView.hidden=YES;
    }
    return _placeHolderView;
}

-(void)dealloc{
  
    
   
}


@end
