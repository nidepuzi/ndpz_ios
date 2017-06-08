//
//  JMGoodsExplainCell.h
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMGoodsExplainCellIdentifier;

typedef void(^storeUpBlock)(UIButton *button);

@class CSGoodsDetailModel;
@interface JMGoodsExplainCell : UITableViewCell

@property (nonatomic, strong) CSGoodsDetailModel *detailModel;
@property (nonatomic, copy) storeUpBlock block;

@end
