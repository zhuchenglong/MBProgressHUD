//
//  UIViewController+GifLoding.m
//  MBProgressHUD
//
//  Created by zhuchenglong on 16/7/31.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "UIViewController+GifLoding.h"
#import "UIImageView+GifImage.h"
#import <objc/message.h>
#import <Masonry.h>

static const void *GifKey = &GifKey;
static const void *TopViewKey = &TopViewKey;
@implementation UIViewController (GifLoding)

- (void)setGifView:(UIImageView *)gifView{
    
    /*
     通过runtime的通过objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy) 方法将我们需要保存的额外信息保存到对象中。
     object:存储了额外信息的对象。
     key:给定一个指向字符串的指针(运行时会给该指针赋值,也就是添加额外信息的key,后边我们取出这个额外信息的时候,会用到这个key)
     value:额外信息的值
     policy:赋值的规则
     */
    objc_setAssociatedObject(self, GifKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)gifView{
    
    /*
     通过runtime的objc_getAssociatedObject(id object, const void *key)方法将上边存进去的额外信息取出来
     object:存储了额外信息的对象。
     key: 存入额外信息的时候，runtime给生成的key
     */
    return objc_getAssociatedObject(self, GifKey);
}

/*
    分类中不加下面的方法会报错reason:'-[ViewController setTopView:]:unrecognized selector sent to instance 0x7fbfa9624360'
    造成unrecognized selector sent to instance XXX，大部分情况下是因为对象被提前release了
*/
-(UIView *)topView{

 return objc_getAssociatedObject(self, TopViewKey);
}

-(void)setTopView:(UIView *)topView{
    objc_setAssociatedObject(self, TopViewKey, topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 显示GIF加载动画
- (void)showGifLoding:(NSArray *)images inView:(UIView *)view
{
    //如果不传图片就使用默认的
    if (!images.count) {
        images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    }
    UIImageView *gifView = [[UIImageView alloc] init];
    
    //如果不上指定加在某个视图上就加在self.view上
    if (!view) {
        view = self.view;
    }
    
    //获取最底层的窗口
    UIWindow *win = [[[UIApplication sharedApplication] windows] lastObject];
    [win makeKeyAndVisible];
    
    self.topView = [[UIView alloc]initWithFrame:win.bounds];
    self.topView .backgroundColor = [UIColor colorWithHue:0
                                              saturation:0
                                              brightness:0 alpha:0];
    [win addSubview:self.topView];
    
    [self.topView addSubview:gifView];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@70);
    }];
    self.gifView = gifView;
    [gifView playGifAnimate:images];
    
}
// 取消GIF加载动画
- (void)hideGufLoding
{
    [self.gifView stopGifAnimate];
    self.gifView = nil;
    [self.topView removeFromSuperview];
    self.topView = nil;
}

- (BOOL)isNotEmpty:(NSArray *)array
{
    if ([array isKindOfClass:[NSArray class]] && array.count) {
        return YES;
    }
    return NO;
}
@end
