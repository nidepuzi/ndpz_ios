//
//  CSPersonalInfoCell.h
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPersonalInfoCell : UITableViewCell


@property (nonatomic, strong) NSDictionary *itemDic;
- (void)configWithItem:(NSDictionary *)itemDic Section:(NSInteger)section Row:(NSInteger)row;


@end
