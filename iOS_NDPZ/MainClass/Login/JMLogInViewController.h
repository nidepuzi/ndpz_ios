//
//  JMLogInViewController.h
//  XLMM
//
//  Created by zhang on 17/5/14.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JMLogInViewController : UIViewController
@property (nonatomic,strong) NSString *returnUrl;

@property (nonatomic, assign) BOOL isFirstLogin;
@property (nonatomic, assign) BOOL isTabBarLogin;


@end
