//
//  ViewController.m
//  MBProgressHUD
//
//  Created by zhuchenglong on 16/7/21.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "ViewController.h"
#import "RequestManager.h"
#import "MBProgressHUD+HUD.h"

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation ViewController
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableHeaderView = [self headView];
    }
    return _tableView;
}

-(UIView *)headView{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 250)];
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.tableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *array = @[@"只显示菊花",@"显示菊花+文字描述",@"显示文字描述-->2秒钟后消失",@"环形进度条+文字描述",@"条状进度条+文字描述",@"自定义图片+文字描述"];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = @"http://images.apple.com/v/iphone-5s/gallery/a/images/download/photo_1.jpg";
    
    
    if (indexPath.row == 0) {
        
    [MBProgressHUD showLoadHUD];
    [RequestManager downLoadWithUrl:url progress:^(double progress) {
         
         NSLog(@"下载进度--->%f",progress);
         
     } success:^(id responseObject) {
         
         [MBProgressHUD hideHUD];//隐藏
         
         _imageView.image = [UIImage imageWithData:responseObject];
         
     } fail:^(NSError *error) {
         [MBProgressHUD showHUDMsg:@"下载失败！"];
     }];
        
    }
    
    if (indexPath.row == 1) {
    
        [MBProgressHUD showLoadHUDMsg:@"加载中..."];
        [RequestManager downLoadWithUrl:url progress:^(double progress) {
            
            NSLog(@"下载进度--->%f",progress);
            
        } success:^(id responseObject) {
            
            [MBProgressHUD hideHUD];//隐藏
            
            _imageView.image = [UIImage imageWithData:responseObject];
            
        } fail:^(NSError *error) {
            [MBProgressHUD showHUDMsg:@"下载失败！"];
        }];
    }
    
    if (indexPath.row == 2) {
        
        [MBProgressHUD showHUDMsg:@"显示文字后一会消失！"];
    }
    
    if (indexPath.row == 3) {
        
        [MBProgressHUD showCircularHUDProgress];
        [RequestManager downLoadWithUrl:url progress:^(double progress) {
            
            NSLog(@"下载进度--->%f",progress);
            
            //必须在主线程中更新progress！！！！
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD getHUDProgress].progress = progress;
            });
            
        } success:^(id responseObject) {
            //隐藏
            [MBProgressHUD hideHUD];
            
            //下载成功
            [MBProgressHUD showCustomViewHUD:@"下载成功！" imageName:@"37x-Checkmark"];
            
            _imageView.image = [UIImage imageWithData:responseObject];
            
        } fail:^(NSError *error) {
            
            [MBProgressHUD showHUDMsg:@"下载失败！"];
            NSLog(@"llllll");
        }];
    }
    
    if (indexPath.row == 4) {
        
        [MBProgressHUD showBarHUDProgress];
        [RequestManager downLoadWithUrl:url progress:^(double progress) {
            
            NSLog(@"下载进度--->%f",progress);
            
            //必须在主线程中更新progress！！！！
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD getHUDProgress].progress = progress;
            });
            
        } success:^(id responseObject) {
            
            [MBProgressHUD hideHUD];//隐藏
   
            [MBProgressHUD showCustomViewHUD:@"下载成功！" imageName:@"succeed"];
            
            _imageView.image = [UIImage imageWithData:responseObject];
            
        } fail:^(NSError *error) {
            
            [MBProgressHUD showHUDMsg:@"下载失败！"];
        }];
    }
    
    if (indexPath.row == 5) {
        
        [MBProgressHUD showCustomViewHUD:@"下载失败！" imageName:@"failed"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
