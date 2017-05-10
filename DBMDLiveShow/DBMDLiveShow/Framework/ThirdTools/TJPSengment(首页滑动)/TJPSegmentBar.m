//
//  TJPSegmentBar.m
//  TJPSengment
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 tangjiapeng. All rights reserved.
//

#import "TJPSegmentBar.h"
#import "UIView+XMGSegmentBar.h"


#define kMinMargin 30
#define kIndicatorMargin 2



@interface TJPSegmentBar ()
{
    // 记录最后一次点击的按钮
    UIButton *_lastBtn;
}
/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;
/** 按钮数据 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;
/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, strong) TJPSegementBarConfig *config;





@end

@implementation TJPSegmentBar

#pragma mark - lazy
- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorHegiht;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - indicatorH - 1, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
    
}

- (TJPSegementBarConfig *)config
{
    if (!_config) {
        _config = [TJPSegementBarConfig defaultConfig];
    }
    return _config;
}





#pragma mark - 接口
+ (instancetype)segmentBarWithFrame:(CGRect)frame {
    TJPSegmentBar *segmentBar = [[TJPSegmentBar alloc] initWithFrame:frame];
    //添加内容承载视图
    return segmentBar;

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //背景
        self.backgroundColor = self.config.segementBarBackColor;
    }
    return self;
}


- (void)updateWithConfig:(void (^)(TJPSegementBarConfig *))configBlock {
    
    if (configBlock) {
        configBlock(self.config);
    }
    
    //按照当前 self.config 刷新UI
    self.backgroundColor = self.config.segementBarBackColor;
    
    for (UIButton *btn in self.itemBtns) {
        
        btn.titleLabel.font = self.config.itemNormalFont;
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectedColor forState:UIControlStateSelected];
    }
    
    //指示器
    self.indicatorView.backgroundColor = self.config.indicatorColor;
    //刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}



- (void)setSelectIndex:(NSInteger)selectIndex {
    
    //数据过滤
    if (self.items.count == 0 || selectIndex < 0 || selectIndex > self.items.count - 1) {
        return;
    }
    _selectIndex = selectIndex;
    UIButton *btn = self.itemBtns[selectIndex];
    [self btnClick:btn];
}



- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    
    //删除之前添加过的组件
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    
    
    
    //根据所有的选项数据源,创建button,添加到内容视图
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        btn.titleLabel.font = self.config.itemNormalFont;
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectedColor forState:UIControlStateSelected];
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
        
    }
    
    //手动刷新布局
    [self setNeedsLayout]; //标记当前刷新 但不刷新
    [self layoutIfNeeded]; //刷新当前 但需要标记
    
    
}

- (void)btnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectedIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectedIndex:btn.tag fromIndex:_lastBtn.tag];
    }
    //此处不能调用self
    _selectIndex = btn.tag;

    
    
    [UIView animateWithDuration:0.15 animations:^{
        _lastBtn.titleLabel.font = self.config.itemNormalFont;
        _lastBtn.selected = NO;
        btn.titleLabel.font = self.config.itemSelectedFont;
        btn.selected = YES;
        _lastBtn = btn;
        
        //手动刷新布局
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
    }];
    
    
    [UIView animateWithDuration:0.15 animations:^{
        self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    //1.先滚动到btn的位置
    CGFloat scrollX = btn.centerX - self.contentView.width * 0.5;
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.width) {
        scrollX = self.contentView.contentSize.width - self.contentView.width;
    }
    
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];    

}






#pragma mark - 布局
- (void)layoutSubviews {
    self.contentView.frame = self.bounds;

    //计算margin
    CGFloat totalBtnWidth = 0;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        totalBtnWidth += btn.width;
    }
    
    CGFloat caculateMargin = (self.width - totalBtnWidth) / (self.items.count + 1);
    if (caculateMargin < kMinMargin) {
        caculateMargin = kMinMargin;
    }
    
    
    CGFloat lastX = caculateMargin;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        
        btn.y = 0;
        
        btn.x = lastX;
        
        lastX += btn.width + caculateMargin;
        
    }
    
    self.contentView.contentSize = CGSizeMake(lastX, 0);
    
    
    if (self.itemBtns.count == 0) {
        return;
    }
    
    UIButton *btn = self.itemBtns[self.selectIndex];
    self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
    self.indicatorView.centerX = btn.centerX;
    self.indicatorView.height = self.config.indicatorHegiht;
    self.indicatorView.y = self.height - self.indicatorView.height - kIndicatorMargin;
    
}








@end
