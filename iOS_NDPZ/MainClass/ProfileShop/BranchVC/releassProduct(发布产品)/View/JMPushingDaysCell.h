//
//  JMPushingDaysCell.h
//  XLMM
//
//  Created by zhang on 17/4/10.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMPushingDaysCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *cellImageView;
- (void)createImageForCellImageView:(NSString *)imageUrl Index:(NSInteger)index RowIndex:(NSInteger)rowIndex;

@end
