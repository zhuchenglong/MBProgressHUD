//
//  NetRequestManager.h
//  HUI
//
//  Created by zhuchenglong on 16/3/15.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 请求类型*/
typedef  NS_ENUM(NSInteger,RequestType)
{
    RequestType_GET,
    RequestType_POST
};

//请求成功的回调
typedef void(^SuccessBlock)(id responseObject);

//请求失败的回调
typedef void(^FailBlock)(NSError * error);

//进度的回调
typedef void (^ProgressBlock)(double progress);

//网络状态的回调
typedef void (^NetworkStatusBlock)(BOOL isHaveNetwork);

@interface RequestManager : NSObject


/**!
 *  @param urlString :url
 *  @param type      :请求类型
 *  @param parameters:参数
 *  @param success   :成功回调
 *  @param fail      :失败回调
 */
+(void)requestWithUrl:(NSString * )urlString
                 Type:(RequestType)type
           parameters:(NSDictionary *)parameters
              Success:(SuccessBlock)success
                 Fail:(FailBlock) fail;


//上传
+(void)upLoadUrl:(NSString * )urlString
           parameters:(NSDictionary *)parameters
              fileURL:(NSURL *)fileURL
             fileName:(NSString *)fileName
              Success:(SuccessBlock)success
                 Fail:(FailBlock)fail
             Progress:(ProgressBlock)progress;

//下载
+(void)downLoadWithUrl:(NSString *)url
              progress:(ProgressBlock)progress
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;


@end
