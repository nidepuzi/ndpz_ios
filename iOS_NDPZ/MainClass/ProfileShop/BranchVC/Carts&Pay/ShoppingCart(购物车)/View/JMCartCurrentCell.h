//
//  JMCartCurrentCell.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMCartCurrentCellIdentifier;

@class CartListModel;

@protocol JMCartCurrentCellDelegate <NSObject>

- (void)addNumber:(CartListModel *)model;
- (void)jianNumber:(CartListModel *)model;
- (void)tapActionNumber:(CartListModel *)model;
- (void)deleteCart:(CartListModel *)model;

@end



@interface JMCartCurrentCell : UITableViewCell

@property (nonatomic, weak) id <JMCartCurrentCellDelegate> delegate;

@property (nonatomic, strong) CartListModel *cartModel;

@end
