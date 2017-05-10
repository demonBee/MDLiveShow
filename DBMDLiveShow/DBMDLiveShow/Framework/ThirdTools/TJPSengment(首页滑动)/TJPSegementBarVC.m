//
//  TJPSegementBarVC.m
//  TJPSengment
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 tangjiapeng. All rights reserved.
//

#import "TJPSegementBarVC.h"
#import "UIView+XMGSegmentBar.h"


@interface TJPSegementBarVC ()<TJPSegmentBarDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *contentView;


@end

@implementation TJPSegementBarVC


#pragma mark - lazy
- (TJPSegmentBar *)segementBar {
    if (!_segementBar) {
        TJPSegmentBar *segementBar = [TJPSegmentBar segmentBarWithFrame:CGRectMake(0, 80, self.view.width, 35)];
        segementBar.delegate = self;
        segementBar.backgroundColor = [UIColor brownColor];
        [self.view addSubview:segementBar];
        _segementBar = segementBar;
        
    }
    return _segementBar;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;


}
- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs {
    
    
    NSAssert(items.count != 0 || items.count == childVCs.count, @"个数不一致, 请自己检查");
    
    self.segementBar.items = items;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    // 添加几个自控制器
    // 在contentView, 展示子控制器的视图内容
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
    
    //
    self.contentView.contentSize = CGSizeMake(items.count * self.view.width, 0);
    
    self.segementBar.selectIndex = 1;
    
    
    
}

- (void)showChildVCViewsAtIndex:(NSInteger)index {
    
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * self.contentView.width, 0, self.contentView.width, self.contentView.height);
    [self.contentView addSubview:vc.view];
    
    // 滚动到对应的位置
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.width, 0) animated:YES];
}




- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.segementBar.superview == self.view) {
        self.segementBar.frame = CGRectMake(0, 60, self.view.width, 35);
        
        CGFloat contentViewY = self.segementBar.y + self.segementBar.height;
        CGRect contentFrame = CGRectMake(0, contentViewY, self.view.width, self.view.height - contentViewY);
        self.contentView.frame = contentFrame;
        self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
        
        return;
    }
    
    
    CGRect contentFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.contentView.frame = contentFrame;
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    
    self.segementBar.selectIndex = self.segementBar.selectIndex;
    
}

#pragma mark - 选项卡代理方法
- (void)segmentBar:(TJPSegmentBar *)segmentBar didSelectedIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
//    NSLog(@"%zd------%zd", fromIndex, toIndex);
    [self showChildVCViewsAtIndex:toIndex];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 计算最后的索引
    NSInteger index = self.contentView.contentOffset.x / self.contentView.width;
    
    //    [self showChildVCViewsAtIndex:index];
    self.segementBar.selectIndex = index;
    
}
@end
