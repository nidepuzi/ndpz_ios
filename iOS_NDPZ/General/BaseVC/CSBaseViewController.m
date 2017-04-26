//
//  CSBaseViewController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/25.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSBaseViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@end

@implementation CSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //点击空白 收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    //返回按钮
    if (self.navigationController && self != self.navigationController.viewControllers.firstObject) {
        [self resetNaviWithTitle:@""];
    }

}
- (void)resetNaviWithTitle:(NSString *)title {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"popBackImage"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"popBackImage"] forState:UIControlStateHighlighted];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
- (void)popBack {
    if (self.presentingViewController) {
        if (self.navigationController &&self.navigationController.viewControllers.count > 1) {             [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}
- (void)showErrorView {
    [[JMGlobal global] showMessageView:self.view message:@"加载出错了,点击屏幕重新加载" withBlock:^(UIView *messageView) {
        [self touchNetFailView:messageView];
    }];
}
- (void)showErrorView:(NSString *)message {
    [[JMGlobal global] showMessageView:self.view message:message withBlock:^(UIView *messageView) {
        [self touchNetFailView:messageView];
    }];
}
- (void)showDataEmptyView {
    [[JMGlobal global] showMessageView:self.view withBlock:^(UIView *messageView) {
        [self touchNetFailView:messageView];
    }];
}
- (void)showDataEmptyViewWithSuperView:(UIView *)view {
    [[JMGlobal global] showMessageView:self.view withBlock:^(UIView *messageView) {
        [self touchNetFailView:messageView];
    }];
}
- (void)showDataEmptyView:(NSString *)message {
    [[JMGlobal global] showMessageView:self.view message:message withBlock:^(UIView *messageView) {
        [self touchNetFailView:messageView];
    }];
}
- (void)showDataEmptyView:(NSString *)message iconImage:(UIImage *)image {
    [[JMGlobal global] showMessageView:self.view message:message iconImage:image withBlock:^(UIView *messageView) {
        [self touchNetFailView:messageView];
    }];
}


- (void)dismissNetFailView {
    [[JMGlobal global] hideMessageView];
}
- (void)touchNetFailView:(UIView *)view {
    [self touchReload];
}
- (void)touchReload {
    NSLog(@"空白页点击.... 然而你点了好像并没有什么用~~ 哈哈哈 ");
}



@end






































