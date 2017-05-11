//
//  DBLivingRoomTopView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBLivingRoomTopView.h"
#import "NewPersonInfoModel.h"

static CGFloat BgViewH = 34;
static CGFloat AttentionBtnH = 23;
static CGFloat TicketBgViewH = 23;
static CGFloat ScrollViewMargin = 20;
static CGFloat HeadImageViewWidth = 32;
static CGFloat HostBgViewW = 128;
#define kStatusBarHeight            20
#define DefaultMargin               10

@interface DBLivingRoomTopView()

@property (nonatomic, weak) UIView *hostBgView; //主播相关的view
/** 头像*/
@property (nonatomic, weak) UIImageView *headImageView;
/** 马币 多少  文字*/
@property (nonatomic, weak) UILabel *ticketCountLabel;
/** 直播人数*/
@property (nonatomic, weak) UILabel *liveCountLab;
/** 直播  名字*/
@property (nonatomic, weak) UILabel *liveLab;
/** 关注按钮*/
@property (nonatomic, weak) UIButton *attentionBtn;




@property (nonatomic, weak) UIView *ticketBgView; //240*46
/** 头像滚动视图*/
@property (nonatomic, weak) UIScrollView *headImageScrollView;
/** 映票ImageView 一个是映票这个字  一个是倒三角  */
@property (nonatomic, weak) UIImageView *ticketImageView;
@property (nonatomic, weak) UIImageView *rightImageView;


/** 映客号*/
@property (nonatomic, weak) UILabel *yingKeNumLab;
/** 日期*/
@property (nonatomic, weak) UILabel *dateLabel;


@property(nonatomic,assign)BOOL isAttention;


//数据
/** 顶部数据  这个是需要吊接口来得到的分页类*/
@property (nonatomic, strong) NSMutableArray *topUsers;
@end

@implementation DBLivingRoomTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.headImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*mainImageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMainPhoto)];
        [self.headImageView addGestureRecognizer:mainImageTap];
        
        self.yingKeNumLab.userInteractionEnabled=YES;
        UITapGestureRecognizer*roomNumber=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRoomNumber)];
        [self.yingKeNumLab addGestureRecognizer:roomNumber];
        
    }
    return self;
}

-(void)setMainModel:(NewPersonInfoModel *)mainModel{
    _mainModel=mainModel;
    
//头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
  
    
    
    //用户名字
    self.liveLab.text=mainModel.nick;
    //是否关注
   
    
    
    //房间号
    self.yingKeNumLab.text=[NSString stringWithFormat:DBGetStringWithKeyFromTable(@"L房间号:%@", nil),mainModel.roomid];
    //时间
    self.dateLabel.text=mainModel.currentTime;

   
   //得到用户和主播的关系 并显示按钮
    [self getUserWithAnchorRelation];
    
    //先获取数据，后开启定时器
    [self updateData];
    //开启定时器  每30秒都吊接口 得到 前20个观众（最新） 总共多少马币 总共多少人数
    [self timer];

    
}

//处理顶部视图
 //主播相关那一揽子的 数据赋值
- (void)dealWithTopUserImageView {
//    //更新父视图宽度
//    NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"Georgia" size:15.f]};
//    CGSize size=[_ticketCountLabel.text sizeWithAttributes:attrs];
//    CGFloat viewW = _ticketImageView.width + size.width + _rightImageView.width + DefaultMargin * 2;
//    [self.ticketBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(viewW);
//    }];

    self.headImageScrollView=nil;
    
    CGFloat width = HeadImageViewWidth;
    
    self.headImageScrollView.contentSize = CGSizeMake((width + DefaultMargin) * self.topUsers.count, 0);
    CGFloat x;
    for (int i = 0; i < self.topUsers.count; i++) {
        UIImageView *userView=[self.headImageScrollView viewWithTag:i+100];
        if (!userView) {
            x = 0 + (DefaultMargin + width) * i;
            userView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 1, width, width)];
            userView.layer.cornerRadius = width * 0.5;
            userView.layer.masksToBounds = YES;
            
            
            //添加监听
            userView.userInteractionEnabled = YES;
            [userView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImageView:)]];
            userView.tag = i+100;
            [self.headImageScrollView addSubview:userView];

        }
        
        NewPersonInfoModel*model=self.topUsers[i];
        [userView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"placeholderPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
              
    }
}




#pragma mark  -- touch
-(void)updateData{
    [self getDatas];
    
    
   
}

- (void)clickHeadImageView:(UITapGestureRecognizer *)gesture {
    if (gesture.view == self.headImageView) { //点击的是主播头像
        
    }else {
        //点击的是顶部头像
        NSInteger number=gesture.view.tag-100;
        NewPersonInfoModel * userInfo = self.topUsers[number];
        NSDictionary*dict=@{@"info":userInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClickUser object:nil userInfo:dict];
    }
}


- (void)attentionBtnClick:(UIButton *)button {
    //点击了 关注
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_FOllowOrCancelFollow];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"user_id":[UserSession instance].user_id,@"anchor_id":self.mainModel.ID,@"is_like":@"1"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [JRToast showWithText:data[@"data"]];

            self.isAttention=YES;
            self.attentionBtn.hidden=YES;
            
            //关注成功了  那么吊通知
            NSDictionary*dict=@{@"nick":[UserSession instance].user_info.nick};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FollowNotification" object:nil userInfo:dict];

            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        
    }];

    
  

}


-(void)clickMainPhoto{
    //点击了 mainPhoto  也吊用通知 跳弹窗
    NewPersonInfoModel * userInfo = self.mainModel;
    NSDictionary*dict=@{@"info":userInfo};
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClickUser object:nil userInfo:dict];

    
}

-(void)clickRoomNumber{
    MyLog(@"111");
    NewPersonInfoModel*userInfo=self.mainModel;
    NSDictionary*dict=@{@"info":userInfo};
    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationTwo object:nil userInfo:dict];
    
}


//布局子控件
- (void)layoutSubviews {
    
    [super layoutSubviews];
   DBSelf(weakSelf)
    [self.hostBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(HostBgViewW, BgViewH));
        make.top.offset(5);
        make.left.offset(10);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(HeadImageViewWidth, HeadImageViewWidth));
        make.left.and.top.offset(1);
    }];
    
    [self.liveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(4);
        make.left.equalTo(weakSelf.headImageView.mas_right).offset(5);
        make.right.mas_equalTo(weakSelf.attentionBtn.mas_left).offset(3);
    }];
    
    [self.liveCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.liveLab.mas_bottom).offset(3);
        make.left.equalTo(weakSelf.headImageView.mas_right).offset(10);
    }];
    
    //    [self.attentionBtn sizeToFit];
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, AttentionBtnH));
        make.top.offset(5);
        make.right.offset(-6);
    }];
    
    [self.ticketBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.size.mas_equalTo(CGSizeMake(120, TicketBgViewH));
        make.height.offset(TicketBgViewH);
        make.width.greaterThanOrEqualTo(@100);//设置最小宽度
        make.top.equalTo(weakSelf.hostBgView.mas_bottom).offset(7);
        make.left.mas_equalTo(weakSelf.hostBgView);
    }];
    [self.ticketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(9);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [self.ticketCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(2);
        make.left.equalTo(weakSelf.ticketImageView.mas_right).offset(1);
        
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(6);
        make.left.equalTo(weakSelf.ticketCountLabel.mas_right).offset(5);
    }];
    
    //更新父视图宽度
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"Georgia" size:15.f]};
    CGSize size=[_ticketCountLabel.text sizeWithAttributes:attrs];
    CGFloat viewW = _ticketImageView.width + size.width + _rightImageView.width + DefaultMargin * 2;
    [self.ticketBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(viewW);
    }];
    
    [self layoutIfNeeded]; //必须手动刷新才能拿到frame
    
    //头像滚动视图
    [self.headImageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.hostBgView);
        make.left.equalTo(weakSelf.hostBgView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth - weakSelf.hostBgView.width - ScrollViewMargin, BgViewH));
    }];
    
    [self.yingKeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headImageScrollView.mas_bottom).offset(5);
        make.right.offset(-10);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.yingKeNumLab.mas_bottom).offset(3);
        make.right.mas_equalTo(weakSelf.yingKeNumLab);
    }];
    
}


#pragma mark  -- 得到Datas
//传直播间的id 得到20个 最近才进来的人   当前的总马币数 总在线观众
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_watcherList];
    NSDictionary*params=@{@"device_id":[DBTools getUUID],@"token":[UserSession instance].user_id,@"anchor_id":self.mainModel.ID,@"pagen":@"20",@"pages":@"0"};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            [self.topUsers removeAllObjects];
            NSArray*array=data[@"data"][@"lists"];
            for (NSDictionary*dict in array) {
                NewPersonInfoModel*model=[NewPersonInfoModel yy_modelWithDictionary:dict];
                [self.topUsers addObject:model];
            }
            
            //成功之后 更新3个界面的数据
            self.liveCountLab.text=data[@"data"][@"total_spectator"];
            self.ticketCountLabel.text=data[@"data"][@"anchor_gift_money"];
            //给顶部赋值
            [self dealWithTopUserImageView];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
    
    
    

}


//得到用户和主播的关系
-(void)getUserWithAnchorRelation{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_UserAndAnchorRelation];
    NSDictionary*params=@{@"user_id":[UserSession instance].user_id,@"device_id":[DBTools getUUID],@"token":[UserSession instance].token,@"anchor_id":self.mainModel.ID};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"errorCode"] integerValue]==0) {
            if ([data[@"data"][@"isFollow"] integerValue]==1) {
                self.isAttention=YES;
                
            }else{
                self.isAttention=NO;
            }
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        // 如果点击了关注 并且成功了 那么需要隐藏按钮
        if (self.isAttention==YES) {
            self.attentionBtn.hidden=YES;
        }else{
            self.attentionBtn.hidden=NO;
        }

        
        
    }];
    
    
};


#pragma mark -- set
#pragma mark - lazy
- (UIView *)hostBgView {
    if (!_hostBgView) {
        UIView *hostBgView = [[UIView alloc] init];
        hostBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        hostBgView.layer.cornerRadius = BgViewH * 0.5;
        hostBgView.clipsToBounds = YES;
        [self addSubview:hostBgView];
        _hostBgView = hostBgView;
    }
    return _hostBgView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        UIImageView *headImageView = [[UIImageView alloc] init];
        [self.hostBgView addSubview:headImageView];
        _headImageView = headImageView;
    }
    return _headImageView;
}

- (UILabel *)liveLab {
    if (!_liveLab) {
        UILabel *liveLab = [[UILabel alloc] init];
        liveLab.text = DBGetStringWithKeyFromTable(@"L主播名字", nil);
        liveLab.textColor = [UIColor whiteColor];
        liveLab.font = [UIFont systemFontOfSize:10.f];
        [self.hostBgView addSubview:liveLab];
        _liveLab = liveLab;
    }
    return _liveLab;
}

- (UILabel *)liveCountLab {
    if (!_liveCountLab) {
        UILabel *liveCountLab = [[UILabel alloc] init];
        liveCountLab.text = @"99999";
        liveCountLab.textColor = [UIColor whiteColor];
        liveCountLab.font = [UIFont systemFontOfSize:10.f];
        [self.hostBgView addSubview:liveCountLab];
        _liveCountLab = liveCountLab;
    }
    return _liveCountLab;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //如果已经关注了 那就隐藏
        [attentionBtn setTitle:DBGetStringWithKeyFromTable(@"L关注", nil) forState:UIControlStateNormal];
        [attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        attentionBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [attentionBtn setBackgroundColor:DBColor(48, 221, 209)];
        attentionBtn.layer.cornerRadius = AttentionBtnH * 0.5;
        attentionBtn.clipsToBounds = YES;
        [attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [attentionBtn setImage:[UIImage imageNamed:@"live_guanzhu_"] forState:UIControlStateNormal];
        [self.hostBgView addSubview:attentionBtn];
        _attentionBtn = attentionBtn;
    }
    return _attentionBtn;
}

- (UIView *)ticketBgView {
    
    if (!_ticketBgView) {
        UIView *ticketBgView = [[UIView alloc] init];
        ticketBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        ticketBgView.layer.cornerRadius = TicketBgViewH * 0.5;
        ticketBgView.clipsToBounds = YES;
        [self addSubview:ticketBgView];
        _ticketBgView = ticketBgView;
    }
    return _ticketBgView;
}

- (UIImageView *)ticketImageView {
    if (!_ticketImageView) {
        UIImageView *ticketImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"货币"]];
        ticketImageView.contentMode=UIViewContentModeScaleAspectFit;
//        [ticketImageView sizeToFit];
        [self.ticketBgView addSubview:ticketImageView];
        _ticketImageView = ticketImageView;
    }
    return _ticketImageView;
}

- (UILabel *)ticketCountLabel {
    if (!_ticketCountLabel) {
        UILabel *ticketCountLabel = [[UILabel alloc] init];
        ticketCountLabel.text = [NSString stringWithFormat:@"%d", (arc4random() % 80000) + 100000];
        [ticketCountLabel setFont:[UIFont fontWithName:@"Georgia" size:15.f]];
        ticketCountLabel.textColor = [UIColor whiteColor];
        [self.ticketBgView addSubview:ticketCountLabel];
        _ticketCountLabel = ticketCountLabel;
        
    }
    return _ticketCountLabel;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_yp_btn_n_"]];
        [rightImageView sizeToFit];
        [self.ticketBgView addSubview:rightImageView];
        _rightImageView = rightImageView;
    }
    return _rightImageView;
}

- (UIScrollView *)headImageScrollView {
    if (!_headImageScrollView) {
        UIScrollView *headScrollView = [[UIScrollView alloc] init];
        headScrollView.showsVerticalScrollIndicator = NO;
        headScrollView.showsHorizontalScrollIndicator = NO;
        //        headScrollView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:headScrollView];
        _headImageScrollView = headScrollView;
    }
    return _headImageScrollView;
}


- (UILabel *)yingKeNumLab {
    if (!_yingKeNumLab) {
        UILabel *yingKeLab = [[UILabel alloc] init];
//        yingKeLab.text = @"房间号:6666666";
        yingKeLab.textColor = DBColor(242, 238, 234);
        yingKeLab.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:yingKeLab];
        _yingKeNumLab = yingKeLab;
    }
    return _yingKeNumLab;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = @"2016.01.01";
        dateLabel.textColor = DBColor(242, 238, 234);
        dateLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
    }
    return _dateLabel;
}


- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer = timer;
    }
    return _timer;
}
//滚动条的数据
-(NSMutableArray *)topUsers{
    if (!_topUsers) {
        _topUsers=[NSMutableArray array];
    }
    return _topUsers;
}


-(void)dealloc{
    MyLog(@"22");
    
}


@end
