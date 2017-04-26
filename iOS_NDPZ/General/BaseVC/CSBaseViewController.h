//
//  CSBaseViewController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/4/25.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSBaseViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL hideTabBar;
@property (nonatomic, assign) BOOL hasBack;


- (void)showErrorView;
- (void)showErrorView:(NSString *)message;
- (void)showDataEmptyView;
- (void)showDataEmptyViewWithSuperView:(UIView *)view;
- (void)showDataEmptyView:(NSString *)message;
- (void)showDataEmptyView:(NSString *)message iconImage:(UIImage *)image;


- (void)dismissNetFailView;
- (void)touchReload;
- (void)popBack;


@end
