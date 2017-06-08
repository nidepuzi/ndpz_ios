//
//  JMPersonAllOrderController.h
//  XLMM
//
//  Created by zhang on 17/4/13.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMPersonAllOrderController : UIViewController


- (void)refresh;
@property (nonatomic, copy) NSString *itemIndex;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) BOOL isShow;


@end
