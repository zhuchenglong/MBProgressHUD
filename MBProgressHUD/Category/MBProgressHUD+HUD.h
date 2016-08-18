//
//  MBProgressHUD+HUD.h
//  MBProgressHUD
//
//  Created by zhuchenglong on 16/7/23.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <UIKit/UIKit.h>

@interface MBProgressHUD (HUD)
/** 只显示菊花 **/
+ (void)showLoadHUD;

/** 显示菊花+文字 **/
+(void)showLoadHUDMsg:(NSString *)message;

/** 显示文字-->几秒钟后消失 **/
+(void)showHUDMsg:(NSString *)message;

/** 环形进度条 + 文字 **/
+(void)showCircularHUDProgress;

/** 水平进度条 + 文字 **/
+(void)showBarHUDProgress;

/** 更新progress进度 **/
+(MBProgressHUD *)getHUDProgress;

/** 自定义图片 + 文字 **/
+(void)showCustomViewHUD:(NSString *)msg imageName:(NSString *)imageName;

+(void)showCustomGifHUD:(NSString *)msg imageName:(NSString *)imageName;
//隐藏HUD
+(void)hideHUD;

@end
