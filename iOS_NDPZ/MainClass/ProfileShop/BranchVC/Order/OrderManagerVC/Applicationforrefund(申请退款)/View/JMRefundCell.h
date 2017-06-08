//
//  JMRefundCell.h
//  XLMM
//
//  Created by zhang on 17/4/15.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSOrderDetailChannels;
@interface JMRefundCell : UITableViewCell

- (void)configWithModel:(CSOrderDetailChannels *)model Index:(NSInteger)index;

- (void)configWithPayModel:(CSOrderDetailChannels *)model Index:(NSInteger)index;

@end
