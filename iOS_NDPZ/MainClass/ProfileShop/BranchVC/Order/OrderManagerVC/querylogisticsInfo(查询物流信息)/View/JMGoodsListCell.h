//
//  JMGoodsListCell.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMGoodsListCellIdentifier;

@class JMOrderGoodsModel;
@interface JMGoodsListCell : UITableViewCell

- (void)configData:(JMOrderGoodsModel *)model;

@end
