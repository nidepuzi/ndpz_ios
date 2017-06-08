//
//  JMOrderDetailController.h
//  XLMM
//
//  Created by zhang on 17/4/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAllOrderModel.h"

@class JMOrderDetailController;
@protocol JMOrderDetailControllerDelegate <NSObject>

- (void)composeWithPopViewRefresh:(JMOrderDetailController *)orderVC;

@end

@interface JMOrderDetailController : UIViewController

@property (nonatomic, weak) id<JMOrderDetailControllerDelegate> delegate;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *orderTid;

@end
