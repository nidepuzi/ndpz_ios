//
//  JMHomeCategoryCell.h
//  XLMM
//
//  Created by zhang on 17/4/19.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMHomeCategoryCellIdentifier;

@class JMHomeCategoryCell;
@protocol JMHomeCategoryCellDelegate <NSObject>

- (void)composeCategoryCellTapView:(JMHomeCategoryCell *)categoryCellView ParamerStr:(NSDictionary *)paramerString;

@end

@interface JMHomeCategoryCell : UITableViewCell

//@property (nonatomic, copy) NSString *imageUrlString;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, weak) id<JMHomeCategoryCellDelegate>delegate;


@end



