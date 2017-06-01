//
//  JMEarningListController.h
//  XLMM
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EarningRecode) {
    EarningRecodeWithTotal,
    EarningRecodeWithWeek,
    EarningRecodeWithMonth
};

@interface JMEarningListController : UIViewController

@property (nonatomic, assign) EarningRecode earningRecodeType;
@property (nonatomic, copy) NSString *earningValue;

@end
