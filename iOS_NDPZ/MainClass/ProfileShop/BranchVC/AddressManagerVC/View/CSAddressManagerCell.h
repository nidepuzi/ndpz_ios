//
//  CSAddressManagerCell.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMAddressModel;
@protocol CSAddressManagerCellDelegate <NSObject>
- (void)modifyAddress:(JMAddressModel*)medel Button:(UIButton *)button;
@end

@interface CSAddressManagerCell : UITableViewCell

@property (assign, nonatomic)id <CSAddressManagerCellDelegate> delegate;

@property (nonatomic, strong) JMAddressModel *addressModel;


@end
