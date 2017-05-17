//
//  JMHomeHourController.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPageScrollController.h"

@interface JMHomeHourController : JMPageScrollController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;



@end
