//
//  UIImageView+GifImage.h
//  MBProgressHUD
//
//  Created by zhuchenglong on 16/7/31.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GifImage)
// 播放GIF
- (void)playGifAnimate:(NSArray *)images;
// 停止动画
- (void)stopGifAnimate;
@end
