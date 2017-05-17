//
//  JMApplyForRefundController.h
//  XLMM
//
//  Created by zhang on 17/4/5.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMOrderGoodsModel.h"

@interface JMApplyForRefundController : UIViewController

@property (nonatomic, strong) JMOrderGoodsModel *dingdanModel;
@property (copy, nonatomic) NSString *tid;
@property (strong, nonatomic) NSDictionary *refundDic;


@end
