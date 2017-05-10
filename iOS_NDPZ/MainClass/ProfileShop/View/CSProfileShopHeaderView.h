//
//  CSProfileShopHeaderView.h
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMMaMaCenterModel.h"

@class CSProfileShopHeaderView;
@protocol CSProfileShopHeaderViewDelegte <NSObject>

- (void)composeProfileShopHeader:(CSProfileShopHeaderView *)headerView ButtonActionClick:(UIButton *)button;
- (void)composeProfileShopHeaderTap:(CSProfileShopHeaderView *)headerView;

@end

@interface CSProfileShopHeaderView : UIView

@property (nonatomic, weak) id <CSProfileShopHeaderViewDelegte> delegate;
@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;
@property (nonatomic, strong) NSArray *mamaResults;
@property (nonatomic, strong) NSDictionary *userInfoDic;

@end



