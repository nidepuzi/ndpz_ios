//
//  JMCartViewController.h
//  XLMM
//
//  Created by zhang on 17/4/15.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCartViewController : UIViewController

@property (nonatomic, assign) BOOL isHideNavigationLeftItem;
@property (nonatomic, copy) NSString *cartType;
- (void)refreshCartData;

@end
