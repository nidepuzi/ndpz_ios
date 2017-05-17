//
//  JMHomeRootCategoryCell.h
//  XLMM
//
//  Created by zhang on 17/4/23.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMHomeRootCategoryCell : UITableViewCell

@property (nonatomic, copy) NSString *nameString;

- (void)configName:(NSString *)nameString Index:(NSInteger)index SelectedIndex:(NSInteger)selectedIndex;


@end
