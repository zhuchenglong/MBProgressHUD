//
//  NetRequestManager.m
//  HUI
//
//  Created by zhuchenglong on 16/3/15.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <Reachability.h>
#import "MBProgressHUD+HUD.h"

#define BaseURL @"http://117.169.34.237"
@implementation RequestManager

#pragma mark -- GET/POST网络请求
+(void)requestWithUrl:(NSString * )urlString Type:(RequestType)type parameters:(NSDictionary *)parameters Success:(SuccessBlock)success Fail:(FailBlock)fail{
    
    //首先判断网络是否可用
    if (![RequestManager isHaveNetwork]) {
        [MBProgressHUD showHUDMsg:@"网络异常,请稍后再试！"];
        return;
    }else{
        NSLog(@"网络不错");
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回值类型
    manager.requestSerializer.timeoutInterval = 30;
    //过滤空字符串
    [AFJSONResponseSerializer serializer].removesKeysWithNullValues = YES;
    
    //过滤空字符串添加请求头*/
    //[manager.requestSerializer setValue:sessionIDStr forHTTPHeaderField:@"Cookie"];

    //设置接受格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];

    switch (type) {
        case RequestType_GET:
        {
            [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
                //打印出来的数据可带双引号
                NSString *sting = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"GetSting ====== %@",sting);
                
            // 将JSON串转化为字典或者数组
            id jsonObject = [self JSONObjectWithData:responseObject];

            //成功后的回调
            if (success){
                success(jsonObject);
            }
                
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                 NSLog(@"Get请求失败%@--->%@",task.response.URL,error);
            
                //失败回调
                if (fail) {
                    fail(error);
                }
            }];
        }
            break;
        case RequestType_POST:
        {
            [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                //打印出来的数据可带双引号
                NSString *sting = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"sting ====== %@",sting);
                
                //获取请求头里面的数据
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSDictionary *allHeaders = response.allHeaderFields;
                NSLog(@"%@",allHeaders);
                
                //字典转换成NSData
                NSData *headersData = [self returnDataWithDictionary:allHeaders];
                NSString *headStr = [[NSString alloc]initWithData:headersData encoding:NSUTF8StringEncoding];
                NSLog(@"headStr +++++++ %@",headStr);
                
                
                id jsonObject = [self JSONObjectWithData:responseObject];
                
                //成功后的回调
                if (success){
                    success(jsonObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败回调
                NSLog(@"POST请求失败%@--->%@",task.response.URL,error);
                if (fail) {
                    fail(error);
                }
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark -- POST上传
+(void)upLoadUrl:(NSString * )urlString parameters:(NSDictionary *)parameters fileURL:(NSURL *)fileURL fileName:(NSString *)fileName Success:(SuccessBlock)success Fail:(FailBlock)fail Progress:(ProgressBlock)progress{
    
    //首先判断网络是否可用
    if (![RequestManager isHaveNetwork]) {
        [MBProgressHUD showHUDMsg:@"网络异常,请稍后再试！"];
        return;
    }else{
        NSLog(@"网络不错");
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //上传时需要
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    
//    //添加请求头
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *sessionID = [userDefaults stringForKey:@"sessionID"];
//    NSString *sessionIDStr = [NSString stringWithFormat:@"aishop.session.id=%@",sessionID];
//    [manager.requestSerializer setValue:sessionIDStr forHTTPHeaderField:@"Cookie"];
    
    //开始请求
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileURL:fileURL name:@"icon" fileName:fileName mimeType:@"image/png" error:nil];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.fractionCompleted);//完成的百分比
        }
        NSLog(@"上传进度：%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        NSLog(@"上传成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
        NSLog(@"上传失败：%@",error);
    }];
}


#pragma mark -- 下载
+(void)downLoadWithUrl:(NSString *)url progress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //首先判断网络是否可用
    if (![RequestManager isHaveNetwork]) {
        [MBProgressHUD showHUDMsg:@"网络异常,请稍后再试！"];
        return;
    }else{
        NSLog(@"网络不错");
    }
    
    //默认传输的数据类型是二进制
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //构造request对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //使用系统类创建downLoad Task对象
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        if (progress) {
            progress(downloadProgress.fractionCompleted);//完成的百分比
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接存放路径
        NSURL *pathURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        
        //返回下载到哪里(返回值是一个路径)
        return [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //此处已经在主线程了
        if (!error){
            
            //文件名称
            NSString *fileName = filePath.lastPathComponent;
            //沙盒documents路径
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
            //文件路径
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath,fileName];
            
            NSData *dataURL = [NSData dataWithContentsOfFile:filePath];
            
            if (success) {
                success(dataURL);
            }
            //如果请求没有错误(请求成功), 则打印地址
            NSLog(@"打印地址-->%@", filePath);
        }else{
            
            if (fail) {
                fail(error);
            }
        }
    }];
    //开始请求
    [task resume];
}


#pragma mark -- 将JSON串转化为字典或者数组
+(id)JSONObjectWithData:(id)responseObject{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    return jsonObject;
}


#pragma mark --将字典转换为NSData
+(NSData *)returnDataWithDictionary:(NSDictionary *)dic{
    
  NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}


#pragma mark -- 设置cookie
+(void)setCookie{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [userDefaults stringForKey:@"sessionID"];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"aishop.session.id" forKey:NSHTTPCookieName];
    [cookieProperties setObject:sessionID forKey:NSHTTPCookieValue];
    [cookieProperties setObject:BaseURL forKey:NSHTTPCookieDomain];
    //[cookieProperties setObject:HOST forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    //[cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*30] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    NSLog(@"打印cookie：%@",cookie);
    
    //获取cookie并将cookie保存到本地，用在WebViewVC里面的为webView设置cookie）
    NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:@"Cookie"];
    [defaults synchronize];
}


#pragma mark -- 清空Cookie
+(void)clearCookie{
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in cookieArray){
        
        [cookieJar deleteCookie:obj];
    }
}


#pragma mark -- 检测网络状态1
+(BOOL)isHaveNetwork{

    BOOL isHaveNetwork;
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            NSLog(@"====当前网络状态不可用=======");
            isHaveNetwork = NO;
            break;
        case ReachableViaWiFi:
            NSLog(@"====当前网络状态为Wifi=======");
            isHaveNetwork = YES;
            break;
        case ReachableViaWWAN:
            NSLog(@"====当前网络状态为流量=======");
            isHaveNetwork = YES;
            break;
    }
    return isHaveNetwork;
}


#pragma mark -- 检测网络状态2（AF自带）
+(void)checkNetworkAvailable:(NetworkStatusBlock)showNetworkStatus{
    
    // 电池条显示网络活动
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //开始监听网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前网络为WAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前网络为WiFi");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络！");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"当前网络为未知网络！");
                break;
            default:
                break;
        }
        if(status == AFNetworkReachabilityStatusReachableViaWWAN||status ==AFNetworkReachabilityStatusReachableViaWiFi){
            showNetworkStatus(YES);
        }else{
            showNetworkStatus(NO);
        }
    }];
}


@end
