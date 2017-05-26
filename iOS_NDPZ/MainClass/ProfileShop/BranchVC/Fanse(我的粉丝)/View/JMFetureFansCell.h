//
//  JMFetureFansCell.h
//  XLMM
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMFetureFansModel,CSFansModel,JMVisitorModel;
@interface JMFetureFansCell : UITableViewCell

// 未来粉丝
- (void)fillData:(JMFetureFansModel *)model;
// 我的访客
- (void)fillVisitorData:(JMVisitorModel *)model;
// 今日粉丝
- (void)configNowFnas:(CSFansModel *)model;



@end
