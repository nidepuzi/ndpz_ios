//
//  UIViewController+NavigationBar.m
//  XLMM
//
//  Created by younishijie on 15/10/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "UIImage+UIImageExt.h"
#import <objc/runtime.h>
#import "JMHomePageController.h"
#import "CSProfileShopController.h"
#import "CSCustomeServiceController.h"

static const void *kVTReuseIdentifier = &kVTReuseIdentifier;

@implementation UIViewController (NavigationBar)

+ (void)load {   // Method Swizzling
    [super load];
    Method viewWillMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method csViewWillMethod = class_getInstanceMethod([self class], @selector(csviewWillAppear:));
    
    Method viewWillDisMethod = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
    Method csViewWillDisMethod = class_getInstanceMethod([self class], @selector(csviewWillDisappear:));
    
//    if (!class_addMethod([self class], @selector(viewWillAppear:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
//        method_exchangeImplementations(fromMethod, toMethod);
//    }
    method_exchangeImplementations(viewWillMethod, csViewWillMethod);
    method_exchangeImplementations(viewWillDisMethod, csViewWillDisMethod);
    
}
- (void)csviewWillAppear:(BOOL)animated {
//    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    NSString *className = NSStringFromClass([self class]);
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
//    if([className rangeOfString:@"UI"].location == NSNotFound){
    if ([className hasPrefix:@"UI"] == NO) {
//        NSLog(@"csviewWillAppear -- > %@",className);
        [MobClick beginLogPageView:className];
    }
    [self csviewWillAppear:animated];
}
- (void)csviewWillDisappear:(BOOL)animated {
    NSString *className = NSStringFromClass([self class]);
    if ([className hasPrefix:@"UI"] == NO) {
//        NSLog(@"csviewWillDisappear -- > %@",className);
        [MobClick endLogPageView:className];
    }
    [self csviewWillDisappear:animated];
}

- (void)createNavigationBarWithTitle:(NSString *)title selecotr:(SEL)aSelector{
    self.navigationController.navigationBar.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.navigationController.navigationBar.barTintColor = [UIColor buttonEnabledBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18.];
    if ([self isMemberOfClass:[JMHomePageController class]] || [self isMemberOfClass:[CSCustomeServiceController class]]) {
        label.font = [UIFont boldSystemFontOfSize:18.];
    }
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    if (aSelector != nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popBackImage"]];
        imageView.frame = CGRectMake(0, 14, 10, 19);
        [button addSubview:imageView];
        [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }else {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}


- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    NSLog(@"downLoadWithURLString %@", url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        NSLog(@"downLoadWithURLString dataWithContentsOfURL %d",data==nil);
        if (data == nil) {
            return;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}



@end



/**  在自己定义的导航栏中或者设计稿中需要去除导航栏的1px横线，主要是颜色太不协调了
 *
     同样,设置tabBar
     [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
     [self.tabBarController.tabBar setShadowImage:[UIImage new]];
 */





























