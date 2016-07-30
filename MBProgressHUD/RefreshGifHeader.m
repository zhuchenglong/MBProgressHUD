//
//  RefreshGifHeader.m
//  MBProgressHUD
//
//  Created by zhuchenglong on 16/7/31.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "RefreshGifHeader.h"

@implementation RefreshGifHeader
- (instancetype)init
{
    if (self = [super init]) {
        
       // self.lastUpdatedTimeLabel.hidden = YES;//隐藏最后刷新时间
        //self.stateLabel.hidden = YES;
        
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]]  forState:MJRefreshStateRefreshing];
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]]  forState:MJRefreshStatePulling];
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]]  forState:MJRefreshStateIdle];
    }
    return self;
}
@end
