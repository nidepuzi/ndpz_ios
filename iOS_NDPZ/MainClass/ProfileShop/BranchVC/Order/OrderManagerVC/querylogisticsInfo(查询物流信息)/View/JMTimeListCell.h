//
//  JMTimeListCell.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMTimeListCellIdentifier;

//@class JMTimeInfoModel;
@interface JMTimeListCell : UITableViewCell

//- (void)configData:(JMTimeInfoModel *)model;

- (void)config:(NSDictionary *)itemDic Index:(NSInteger)index;

@end
