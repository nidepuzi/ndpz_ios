//
//  JMHomeHourCell.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMHomeHourModel,JMHomeHourCell;
@protocol JMHomeHourCellDelegate <NSObject>

- (void)composeHourCell:(JMHomeHourCell *)cell Model:(JMHomeHourModel *)model ButtonClick:(UIButton *)button;


@end

@interface JMHomeHourCell : UITableViewCell

@property (nonatomic, weak) id<JMHomeHourCellDelegate> delegate;
@property (nonatomic, strong) JMHomeHourModel *model;


@end
