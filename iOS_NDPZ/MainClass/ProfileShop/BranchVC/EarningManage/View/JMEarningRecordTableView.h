//
//  JMEarningRecordTableView.h
//  XLMM
//
//  Created by zhang on 17/4/2.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMEarningRecordTableView : UITableView

- (void)refreshWithData:(id)numberOfRows atIndex:(NSInteger)index;

@end