//
//  RootNavigationController.m
//  XLMM
//
//  Created by zhang on 17/4/25.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController () <UINavigationControllerDelegate>


@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor buttonEnabledBackgroundColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.delegate = self;
}
/**
 *  第一次使用这个类的时候调用(一个类只会调用一次)
 */
+ (void)initialize {
    
    // 获取当前类下面的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateHighlighted];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;

    }
    [super pushViewController:viewController animated:animated];
    
    
}

@end












































































