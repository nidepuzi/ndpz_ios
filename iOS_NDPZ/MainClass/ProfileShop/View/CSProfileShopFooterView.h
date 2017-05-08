//
//  CSProfileShopFooterView.h
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSProfileShopFooterView;
@protocol CSProfileShopFooterViewDelegte <NSObject>

- (void)composeProfileShopFooter:(CSProfileShopFooterView *)headerView ButtonActionClick:(UIButton *)button;

@end

@interface CSProfileShopFooterView : UIView

@property (nonatomic, weak) id <CSProfileShopFooterViewDelegte> delegate;
@property (nonatomic, strong) NSNumber *accountMoney;

@end
