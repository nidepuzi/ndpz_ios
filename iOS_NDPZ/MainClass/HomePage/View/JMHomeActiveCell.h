//
//  JMHomeActiveCell.h
//  XLMM
//
//  Created by zhang on 17/4/19.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMHomeActiveModel.h"

extern NSString *const JMHomeActiveCellIdentifier;

@interface JMHomeActiveCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *activeDic;

@property (nonatomic, strong) JMHomeActiveModel *model;

@end
