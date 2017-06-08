//
//  JMGoodsLoopRollCell.h
//  XLMM
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSGoodsDetailContentModel;
@interface JMGoodsLoopRollCell : UICollectionViewCell

- (void)refreshScrollViewWithModel:(CSGoodsDetailContentModel *)model Index:(NSInteger)index;

@end
