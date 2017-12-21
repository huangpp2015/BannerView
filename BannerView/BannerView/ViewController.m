//
//  ViewController.m
//  BannerView
//
//  Created by 黄盼盼 on 21/12/17.
//  Copyright © 2017年 panpan. All rights reserved.
//

#import "ViewController.h"
#import "HppBannerView.h"

@interface ViewController ()
@property (strong, nonatomic) HppBannerView *bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.bannerView];
}

- (HppBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [[HppBannerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
        NSMutableArray *imageViewArray = [NSMutableArray arrayWithCapacity:3];
        for (NSInteger i = 0; i < 3; i ++) {
            HppBannerModel *model = [HppBannerModel new];
            model.imageString = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513854519589&di=e1db6a82d71c57761e7a69cbbcfb6bbf&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160814%2F2cc4481500844d529d9b4f2b8b95a4a0_th.jpg";
            [imageViewArray addObject:model];
        }
        _bannerView.dataArray = imageViewArray;
    }
    
    return _bannerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
