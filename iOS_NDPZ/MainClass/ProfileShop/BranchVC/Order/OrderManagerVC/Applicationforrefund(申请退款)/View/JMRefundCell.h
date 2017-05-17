//
//  JMRefundCell.h
//  XLMM
//
//  Created by zhang on 17/4/15.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAppForRefundModel.h"
#import "JMContinuePayModel.h"

@interface JMRefundCell : UITableViewCell

- (void)configWithModel:(JMAppForRefundModel *)model Index:(NSInteger)index;

- (void)configWithPayModel:(JMContinuePayModel *)model Index:(NSInteger)index;

@end
