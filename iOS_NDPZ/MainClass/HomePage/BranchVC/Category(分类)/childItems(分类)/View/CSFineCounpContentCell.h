//
//  CSFineCounpContentCell.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/18.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMFineCouponModel,CSFineCounpContentCell;

@protocol CSFineCounpContentCellDelegate <NSObject>

- (void)composeHourCell:(CSFineCounpContentCell *)cell Model:(JMFineCouponModel *)model ButtonClick:(UIButton *)button;


@end

@interface CSFineCounpContentCell : UICollectionViewCell

@property (nonatomic, weak) id<CSFineCounpContentCellDelegate> delegate;
@property (nonatomic, strong) JMFineCouponModel *model;

@end
