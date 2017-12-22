//
//  HppBannerView.h
//  BannerView
//
//  Created by 黄盼盼 on 21/12/17.
//  Copyright © 2017年 panpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HppBannerView;
@protocol HppBannerViewDelegate <NSObject>

- (void)bannerView:(HppBannerView *)bannerView didSelecteImageAtIndex:(NSInteger)index;

@end
typedef void(^imageTapBlock)(NSString *imageUrl, NSInteger index);

@interface HppBannerModel : NSObject
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *pageUrl;
@end

@interface HppBannerView : UIView
@property (strong, nonatomic) NSArray <HppBannerModel *> *dataArray;
@property (weak, nonatomic) id <HppBannerViewDelegate> delegate;
@end
