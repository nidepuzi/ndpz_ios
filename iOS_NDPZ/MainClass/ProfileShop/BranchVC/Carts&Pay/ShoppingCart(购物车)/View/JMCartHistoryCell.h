//
//  JMCartHistoryCell.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMCartHistoryCellIdentifier;

@class CartListModel;

@protocol JMCartHistoryCellDelegate <NSObject>


- (void)tapActionHistory:(CartListModel *)model;
- (void)addCart:(CartListModel *)model;



@end

@interface JMCartHistoryCell : UITableViewCell

@property (nonatomic, weak) id <JMCartHistoryCellDelegate> delegate;

@property (nonatomic, strong) CartListModel *cartModel;

@end
