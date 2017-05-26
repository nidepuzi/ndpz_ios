//
//  JMGoodsSafeGuardCell.h
//  XLMM
//
//  Created by zhang on 17/4/11.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMGoodsSafeGuardCellIdentifier;

typedef void(^jumpWebViewBlock)(UIButton *button);

@interface JMGoodsSafeGuardCell : UITableViewCell

@property (nonatomic, copy) jumpWebViewBlock block;

@end
