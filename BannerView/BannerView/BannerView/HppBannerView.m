//
//  HppBannerView.m
//  BannerView
//
//  Created by 黄盼盼 on 21/12/17.
//  Copyright © 2017年 panpan. All rights reserved.
//

#import "HppBannerView.h"
#import "UIButton+WebCache.h"

@interface HppBannerView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HppBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        self.scrollView.frame = self.bounds;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
}

- (void)setUpUI {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
        
//      设置tintColor
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
}


- (void)setDataArray:(NSArray *)dataArray {
    
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    
    NSArray *subviews = self.scrollView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    [_timer invalidate];
    _timer = nil;
    
    if (_dataArray.count == 0) {
        return;
        
    } else if (_dataArray.count == 1) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.pageControl.hidden = YES;
        
    } else {
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake((dataArray.count + 2) * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        self.scrollView.pagingEnabled = YES;
        
        self.pageControl.enabled = NO;
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = dataArray.count;
        self.pageControl.currentPage = 0;
        [self addTimer];
    }
    [self setContent];

}
- (void)setContent {
    NSInteger dataCount = _dataArray.count == 1 ? 1 : (_dataArray.count + 2);
    
    for (int i = 0; i < dataCount; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1000;
        HppBannerModel *model;
        
        if (i == 0) {
            model = _dataArray.lastObject;
            button.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            
        }else if(i == _dataArray.count + 1){
            model = _dataArray.firstObject;
            button.frame = CGRectMake(CGRectGetWidth(self.frame) *(_dataArray.count + 1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            
        }else{
            model = _dataArray[i - 1];
            button.frame = CGRectMake(CGRectGetWidth(self.frame) * i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imageString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
    }
    
    [self.pageControl sizeToFit];

}

- (void)addTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(pageCirculation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)pageCirculation {
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = _scrollView.contentOffset ;
        _scrollView.contentOffset = CGPointMake(point.x +  CGRectGetWidth(self.frame), 0);
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_dataArray.count == 1){
        return ;
    }
    if (scrollView.contentOffset.x == (_dataArray.count + 1) * CGRectGetWidth(self.frame)) {
        [UIView performWithoutAnimation:^{
            scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
            _pageControl.currentPage = 0;
        }];
    }else if (scrollView.contentOffset.x == 0){
        [UIView performWithoutAnimation:^{
            scrollView.contentOffset = CGPointMake(_dataArray.count * CGRectGetWidth(self.frame), 0);
            _pageControl.currentPage = _dataArray.count - 1;
        }];
    }else{
        _pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.frame) -1 ;
    }
}



- (void)addTapAction:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    HppBannerModel *model;
    if (index == 0) {
        model = _dataArray.lastObject;
        
    }else if(index == _dataArray.count + 1){
        model = _dataArray.firstObject;
        
    }else{
        model = _dataArray[index - 1];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelecteImageAtIndex:)]) {
        __weak typeof(self) weakSelf = self;
        [self.delegate bannerView:weakSelf didSelecteImageAtIndex:[weakSelf.dataArray indexOfObject:model]];
    } else return;
    
}
@end

@implementation HppBannerModel

@end



