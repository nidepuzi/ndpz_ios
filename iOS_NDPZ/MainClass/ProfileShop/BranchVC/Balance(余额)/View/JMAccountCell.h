//
//  JMAccountCell.h
//  XLMM
//
//  Created by zhang on 17/4/28.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;
@interface JMAccountCell : UITableViewCell

- (void)fillDataOfCell:(AccountModel *)accountM;

@end
