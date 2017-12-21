//
//  HppBannerView.h
//  BannerView
//
//  Created by 黄盼盼 on 21/12/17.
//  Copyright © 2017年 panpan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageTapBlock)(NSString *imageUrl, NSString *responseUrl);

@interface HppBannerModel : NSObject
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *pageUrl;
@end

@interface HppBannerView : UIView
@property (strong, nonatomic) NSArray <HppBannerModel *> *dataArray;
@property (copy, nonatomic) imageTapBlock tapBlock;
@end
