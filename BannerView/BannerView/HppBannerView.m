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
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor orangeColor];
        self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [_timer invalidate];
    _timer = nil;
    
    if (dataArray.count == 0) {
        return;
        
    } else if (dataArray.count == 1) {
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _scrollView.contentOffset = CGPointMake(0, 0);
        _pageControl.hidden = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.tag = 1000;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray.firstObject.imageString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(adTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
    } else {
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake((dataArray.count + 2) * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _pageControl.enabled = NO;
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = dataArray.count;
        _pageControl.currentPage = 0;
        [self setContent];
        
    }
}
- (void)setContent {
    
    for (int i = 0; i < _dataArray.count + 2; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1000;
        HppBannerModel *model;
        if (i == 0) {
            model = _dataArray.lastObject;
            button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            
        }else if(i == _dataArray.count + 1){
            model = _dataArray.firstObject;
            button.frame = CGRectMake(CGRectGetWidth(self.frame) *(_dataArray.count + 1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            button.tag = i + 1000;
            
        }else{
            model = _dataArray[i - 1];
            button.frame = CGRectMake(CGRectGetWidth(self.frame) * i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            button.tag = i + 1000;
        }
        button.backgroundColor = [UIColor grayColor];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imageString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(adTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
    }
    
    [self addTimer];
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



- (void)adTapAction:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    HppBannerModel *model;
    if (index == 0) {
        model = _dataArray.lastObject;
        
    }else if(index == _dataArray.count + 1){
        model = _dataArray.firstObject;
        
    }else{
        model = _dataArray[index - 1];
    }
    
    if (self.tapBlock) {
        self.tapBlock(model.imageString, model.pageUrl);
    } else return;
    
}
@end

@implementation HppBannerModel

@end


