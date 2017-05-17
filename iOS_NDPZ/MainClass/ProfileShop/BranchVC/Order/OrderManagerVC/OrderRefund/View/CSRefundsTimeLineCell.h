//
//  CSRefundsTimeLineCell.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/17.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const CSRefundsTimeLineCellIdentifier;


@interface CSRefundsTimeLineCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *itemDic;

- (void)configWithDic:(NSDictionary *)dic Index:(NSInteger)index AllCount:(NSInteger)count;

@end
