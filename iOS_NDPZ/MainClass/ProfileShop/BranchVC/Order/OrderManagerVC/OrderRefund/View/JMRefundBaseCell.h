//
//  JMRefundBaseCell.h
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMRefundBaseCellIdentifier;

@class JMRefundModel;

@interface JMRefundBaseCell : UITableViewCell

- (void)configRefund:(JMRefundModel *)refundModel;
- (void)configRefundDetail:(JMRefundModel *)refundModel;

@end
