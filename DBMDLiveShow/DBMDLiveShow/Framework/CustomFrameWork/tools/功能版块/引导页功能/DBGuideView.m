//
//  DBGuideView.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBGuideView.h"

@interface DBGuideView()
@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UIPageControl*pageControl;
@end

@implementation DBGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        self.backgroundColor=[UIColor redColor];
        
     
        [self addScrollView];

    
    }
    return self;
}


-(void)addScrollView{
    NSArray*allDatas=@[@"lb1.jpg",@"lb2.jpg",@"lb3.jpg",@"lb4.jpg"];
    
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:self.frame];
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.contentSize=CGSizeMake(KScreenWidth*allDatas.count, KScreenHeight);
    scrollView.pagingEnabled=YES;
    scrollView.bounces=NO;
    scrollView.delegate=self;
    [self addSubview:scrollView];
    self.scrollView=scrollView;
    
    UIPageControl*pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(40),KScreenHeight-ACTUAL_HEIGHT(80), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(25))];
    pageControl.numberOfPages=allDatas.count;
    pageControl.currentPage=0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [self addSubview:pageControl];  //将UIPageControl添加到主界面上。
    self.pageControl=pageControl;
    
    
    for (int i=0; i<allDatas.count; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        //        imageView.backgroundColor=[UIColor whiteColor];r
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [scrollView addSubview:imageView];
        imageView.image=[UIImage imageNamed:allDatas[i]];
        
        
    }
    
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake((allDatas.count-1)*KScreenWidth+30, KScreenHeight-50, KScreenWidth-60, 40)];
    button.backgroundColor=KNaviColor;
    button.layer.cornerRadius=15;
    button.layer.masksToBounds=YES;
    [button setTitle:DBGetStringWithKeyFromTable(@"L点击进入", nil)];
    [button addTarget:self action:@selector(touchButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageControl setCurrentPage:offset.x / bounds.size.width];
    //    NSLog(@"%f",offset.x / bounds.size.width);
}

//然后是点击UIPageControl时的响应函数pageTurn


- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
}


-(void)touchButton{
    [self removeFromSuperview];
    
}



@end
